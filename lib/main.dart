import 'package:flutter/material.dart';
import 'package:rock_classifier/home_page.dart';
import 'intro_home_screen.dart'; // Import file mới
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Sử dụng HomeScreen thay vì Scaffold trực tiếp
    );
  }
}
