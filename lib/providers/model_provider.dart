import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:crux/src/rust/api/model_manager.dart';

part 'model_provider.g.dart';

// --- 1. Startup Check Provider ---
@riverpod
Future<ModelStatus> modelStatus(Ref ref) async {
  return await ModelManager.checkStatus();
}

// --- 2. Download Logic Provider ---

class DownloadState {
  final double progress;
  final bool isDownloading;
  final String? error;
  final bool isComplete;

  const DownloadState({
    this.progress = 0.0,
    this.isDownloading = false,
    this.error,
    this.isComplete = false,
  });

  // Standard copyWith pattern prevents accidental nulling
  DownloadState copyWith({
    double? progress,
    bool? isDownloading,
    String? error,
    bool? isComplete,
  }) {
    return DownloadState(
      progress: progress ?? this.progress,
      isDownloading: isDownloading ?? this.isDownloading,
      // If you pass error, use it. If not, keep old error.
      // To clear error, pass an empty string or handle logic in the Notifier.
      error: error ?? this.error,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  // Helper to clear error explicitly if needed
  DownloadState clearError() => DownloadState(
    progress: progress,
    isDownloading: isDownloading,
    isComplete: isComplete,
    error: null,
  );
}

@riverpod
class Downloader extends _$Downloader {
  @override
  DownloadState build() {
    return const DownloadState();
  }

  Future<void> startDownload() async {
    if (state.isDownloading) return;

    // Reset state for new download
    state = state.copyWith(isDownloading: true).clearError();

    try {
      final Stream<ModelDownloadEvent> stream = ModelManager.downloadModel();

      await for (final event in stream) {
        switch (event) {
          case ModelDownloadEvent_Progress(:final field0):
            state = state.copyWith(progress: field0);

          case ModelDownloadEvent_Completed():
            state = state.copyWith(
              progress: 1.0,
              isComplete: true,
              isDownloading: false,
            );

            // Tell the status provider to re-check the disk.
            // This updates the UI from "Downloading..." to "Ready" automatically.
            ref.invalidate(modelStatusProvider);
        }
      }
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: "Download failed: ${e.toString()}",
      );
    }
  }
}
