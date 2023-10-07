import 'package:flutter/material.dart';
import 'package:image_downloader/src/pages/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Downloader',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
