import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData brownTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Colors.blueAccent,
  scaffoldBackgroundColor: Colors.grey[100],
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);

final ThemeData primaryTheme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(),
  useMaterial3: true,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shadowColor: Colors.amber,
      backgroundColor: Color(0xffE57C3B),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
  ),
);
