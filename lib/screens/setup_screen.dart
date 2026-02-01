import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crux/providers/model_provider.dart';
import 'package:crux/screens/dashboard_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(downloaderProvider);

    // Listener for Navigation Side-Effects
    ref.listen(downloaderProvider, (previous, next) {
      if (next.isComplete) {
        // Invalidate the check so it refreshes to "Present" if needed,
        // or just navigate directly.
        ref.invalidate(modelStatusProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          width: 400, // Constrain width for desktop look
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Intelligence Engine Required",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Crux runs 100% locally. To proceed, we need to download the Gemma 3n E4B model (4.24 GB) to your AppData folder.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 32),

              if (downloadState.error != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.red[50],
                  child: Text(
                    downloadState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              if (downloadState.isDownloading) ...[
                LinearProgressIndicator(value: downloadState.progress),
                const SizedBox(height: 8),
                Text(
                  "${(downloadState.progress * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(downloaderProvider.notifier).startDownload();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download Engine (4.2 GB)"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
