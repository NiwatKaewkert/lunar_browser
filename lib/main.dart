import 'package:flutter/material.dart';
import 'package:lunar_browser/webview/lunar_web_view_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LunarWebViewScreen(),
    );
  }
}
