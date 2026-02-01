use crate::frb_generated::StreamSink;
use anyhow::{anyhow, Context, Result};
use directories::ProjectDirs;
use futures_util::StreamExt;
use reqwest::header::RANGE;
use std::fs::{self};
use std::io::{Seek, SeekFrom, Write};
use std::path::PathBuf;

const MODEL_REPO: &str = "google/gemma-3-4b-it-qat-q4_0-gguf";
const MODEL_FILENAME: &str = "gemma-3-4b-it-qat-q4_0.gguf";

pub enum ModelStatus {
    Missing,
    Present(String), // Returns the absolute path
}

pub enum ModelDownloadEvent {
    Progress(f32),
    Completed(String), // The path
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

    pub async fn download_model(sink: StreamSink<ModelDownloadEvent>) -> Result<()> {
        let dir = Self::get_model_dir()?;
        let final_path = dir.join(MODEL_FILENAME);
        let part_path = dir.join(format!("{}.part", MODEL_FILENAME)); // 1. Use a temporary extension

        // 2. If final file exists, return immediately (or verify hash)
        if final_path.exists() {
            sink.add(ModelDownloadEvent::Completed(
                final_path.to_string_lossy().into_owned(),
            ))
            .map_err(|_| anyhow!("Stream closed"))?;
            return Ok(());
        }

        let mut downloaded: u64 = 0;
        if part_path.exists() {
            downloaded = fs::metadata(&part_path)?.len();
        }

        let url = format!(
            "https://huggingface.co/{}/resolve/main/{}",
            MODEL_REPO, MODEL_FILENAME
        );

        let client = reqwest::Client::new();

        // 3. Send Request
        // Note: We don't error immediately on status here, we check it below
        let response = client
            .get(&url)
            .header(RANGE, format!("bytes={}-", downloaded))
            .send()
            .await
            .context("Failed to connect to HuggingFace")?;

        let status = response.status();

        // 4. Handle HTTP 200 vs 206 (Partial)
        // If server returns 200 OK (refuses range) but we have partial data,
        // we must truncate our local file or we will corrupt it by appending header to body.
        let mut file_mode_append = true;

        if status == reqwest::StatusCode::OK {
            // Server ignored Range header, sending full file. Restart download.
            downloaded = 0;
            file_mode_append = false;
        } else if status != reqwest::StatusCode::PARTIAL_CONTENT {
            return Err(anyhow!("Unexpected server status: {}", status));
        }

        let total_size = if status == reqwest::StatusCode::PARTIAL_CONTENT {
            downloaded + response.content_length().unwrap_or(0)
        } else {
            response.content_length().unwrap_or(0)
        };
        let mut file = std::fs::OpenOptions::new()
            .create(true)
            .write(true)
            .append(file_mode_append) // Append only if resuming
            .open(&part_path)
            .context("Failed to open model file")?;

        // If we got a 200 OK but had a partial file, truncate it now
        if !file_mode_append {
            file.set_len(0)?;
            file.seek(SeekFrom::Start(0))?;
        }

        let mut stream = response.bytes_stream();

        while let Some(item) = stream.next().await {
            let chunk = item.context("Error while downloading chunk")?;
            file.write_all(&chunk).context("Error writing to file")?;

            downloaded += chunk.len() as u64;

            if total_size > 0 {
                let progress = downloaded as f32 / total_size as f32;
                let _ = sink.add(ModelDownloadEvent::Progress(progress));
            }
        }

        // 6. Rename and Finish
        fs::rename(&part_path, &final_path).context("Failed to rename completed file")?;

        sink.add(ModelDownloadEvent::Completed(
            final_path.to_string_lossy().into_owned(),
        ))
        .map_err(|_| anyhow!("Stream closed"))?;

        Ok(())
    }
}
