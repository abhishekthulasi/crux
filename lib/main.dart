import 'package:flutter/material.dart';
import 'package:crux/src/rust/api/simple.dart';
import 'package:crux/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text(greet(name: 'Abhishek'))),
      ),
    );
  }
}
