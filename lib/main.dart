import 'package:flutter/material.dart';
import 'package:moodtracker/Page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return MaterialApp(
      theme: isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      home: const HomePage()
    );
  }
}