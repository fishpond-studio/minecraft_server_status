import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/picture_change.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Is MC FK Running?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 158, 183),
        ),
      ),
      home: const Homepage(),
      routes: {'/picture_change': (context) => const PictureChange()},
    );
  }
}
