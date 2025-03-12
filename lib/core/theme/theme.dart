import 'package:flutter/material.dart';

final ThemeData primaryTheme = ThemeData(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 38,
        fontWeight: FontWeight.bold), //Text loginin
    titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold), // Text quay lại , trang chủ ...
    titleSmall: TextStyle(color: Colors.grey, fontSize: 16), // Text input label
    bodyLarge: TextStyle(color: Colors.black, fontSize: 20),
    bodySmall: TextStyle(color: Colors.grey, fontSize: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xffE57C3B),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
  ),
);

// final ThemeData secondaryTheme = ThemeData(
//   primaryColor: Colors.red,
//   scaffoldBackgroundColor: Colors.black,
//   textTheme: TextTheme(
//     titleLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 36,
//         fontWeight: FontWeight.bold), //Text loginin
//     titleMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold), // Text quay lại , trang chủ ...
//     bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
//     bodySmall: TextStyle(color: Colors.grey, fontSize: 16),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xffFFC4A4),
//           foregroundColor: Colors.grey,
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           shape:
//               BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)))),
//   inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.amber, width: 2)),
//       enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.white, width: 1))),
// );
