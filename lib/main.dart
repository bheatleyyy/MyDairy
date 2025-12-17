import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyDairyApp());
}

class MyDairyApp extends StatelessWidget {
  const MyDairyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDairy',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
    );
  }
}
