import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData brownTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.robotoTextTheme(),
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
