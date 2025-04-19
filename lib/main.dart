import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/core/theme/theme.dart';
import 'package:rock_classifier/firebase_options.dart';
import 'package:rock_classifier/views/users/intro_screen.dart';
import 'package:rock_classifier/modelViews/auth_provider.dart';
import 'package:rock_classifier/modelViews/theme_provider.dart';
import 'package:rock_classifier/modelViews/user_provider.dart';
import 'package:rock_classifier/views/admin/function_update/function_update_information_admin.dart';
import 'package:rock_classifier/views/admin/home_page_admin.dart';
import 'package:rock_classifier/views/admin/information_page_admin.dart';
import 'package:rock_classifier/views/admin/main_page_admin.dart';
import 'package:rock_classifier/views/users/home_page_user.dart';
import 'package:rock_classifier/views/users/login_page.dart';
import 'package:rock_classifier/views/users/register_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modelViews/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // khởi tạo đầy đủ các chức năng của Flutter FrameWork
  await Firebase.initializeApp(); // Khỏi tạo firebase trong dự án
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: brownTheme,
      debugShowCheckedModeBanner: false,
      home:
          (), // Sử dụng HomeScreen thay vì Scaffold trực tiếp
    );
  }
}
