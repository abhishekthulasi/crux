import 'package:crux/src/rust/api/model_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crux/providers/model_provider.dart';
import 'package:crux/screens/setup_screen.dart';
import 'package:crux/screens/dashboard_screen.dart';

class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(modelStatusProvider);

    return statusAsync.when(
      data: (status) {
        // Check Rust Enum: Present or Missing
        return status.when(
          present: (path) => const DashboardScreen(),
          missing: () => const SetupScreen(),
        );
      },
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Initialization Error: $err'))),
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Initializing Crux Engine..."),
            ],
          ),
        ),
      ),
    );
  }
}
