use crate::frb_generated::StreamSink;
use anyhow::{anyhow, Context, Result};
use directories::ProjectDirs;
use futures_util::StreamExt;
use std::fs::{self};
use std::io::Write;
use std::path::PathBuf;

const MODEL_REPO: &str = "google/gemma-3-4b-it-qat-q4_0-gguf";
const MODEL_FILENAME: &str = "gemma-3-4b-it-qat-q4_0.gguf";

pub enum ModelStatus {
    Missing,
    Present(String), // Returns the absolute path
}

pub struct ModelManager {}

impl ModelManager {
    /// Resolves the app data directory (e.g., AppData/Roaming/Crux on Windows)
    fn get_model_dir() -> Result<PathBuf> {
        let proj_dirs = ProjectDirs::from("com", "crux", "crux_app")
            .ok_or_else(|| anyhow!("Could not determine home directory"))?;

        let data_dir = proj_dirs.data_dir();
        if !data_dir.exists() {
            fs::create_dir_all(data_dir).context("Failed to create app data directory")?;
        }
        Ok(data_dir.to_path_buf())
    }

    pub fn check_status() -> Result<ModelStatus> {
        let dir = Self::get_model_dir()?;
        let file_path = dir.join(MODEL_FILENAME);

        if file_path.exists() {
            // Optional: Check file size or hash here for integrity
            Ok(ModelStatus::Present(
                file_path.to_string_lossy().into_owned(),
            ))
        } else {
            Ok(ModelStatus::Missing)
        }
    }

    pub async fn download_model(sink: StreamSink<f32>) -> Result<String> {
        let dir = Self::get_model_dir()?;
        let final_path = dir.join(MODEL_FILENAME);
        let part_path = dir.join(format!("{}.part", MODEL_FILENAME)); // 1. Use a temporary extension

        // 2. If final file exists, return immediately (or verify hash)
        if final_path.exists() {
            sink.add(1.0).map_err(|_| anyhow!("Stream closed"))?;
            return Ok(final_path.to_string_lossy().into_owned());
        }

        // 3. Check for partial download to resume
        let mut downloaded: u64 = 0;
        if part_path.exists() {
            downloaded = std::fs::metadata(&part_path)?.len();
        }

        // Construct URL
        let url = format!(
            "https://huggingface.co/{}/resolve/main/{}",
            MODEL_REPO, MODEL_FILENAME
        );

        // 4. Send Request with "Range" header
        let client = reqwest::Client::new();
        let response = client
            .get(&url)
            .header("Range", format!("bytes={}-", downloaded)) // Resume from where we left off
            .send()
            .await
            .context("Failed to connect to HuggingFace")?;

        // Handle server response codes
        let status = response.status();
        if !status.is_success() {
            return Err(anyhow!("Server returned error: {}", status));
        }

        // Calculate total size (Content-Length is only the *remaining* chunk in a Range response)
        let content_length = response.content_length().unwrap_or(0);
        let total_size = downloaded + content_length;

        // 5. Open file in Append mode if resuming, Create if new
        let mut file = std::fs::OpenOptions::new()
            .create(true)
            .write(true)
            .append(true) // Crucial for resuming
            .open(&part_path)
            .context("Failed to open model file")?;

        let mut stream = response.bytes_stream();

        while let Some(item) = stream.next().await {
            let chunk = item.context("Error while downloading chunk")?;
            file.write_all(&chunk).context("Error writing to file")?;

            downloaded += chunk.len() as u64;

            // Prevent division by zero
            if total_size > 0 {
                let progress = downloaded as f32 / total_size as f32;
                let _ = sink.add(progress);
            }
        }

        // 6. Rename .part to final filename (Atomic commit)
        std::fs::rename(&part_path, &final_path).context("Failed to rename completed file")?;

        sink.add(1.0).map_err(|_| anyhow!("Stream closed"))?;
        Ok(final_path.to_string_lossy().into_owned())
    }
}
