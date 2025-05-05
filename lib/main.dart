import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/Core/theme/theme.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/firebase_options.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_information_admin.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_password_admin/update_password_admin.dart';
import 'package:rock_classifier/Views/users/intro_widget/intro_screen.dart';
import 'package:rock_classifier/ModelViews/auth_provider.dart';
import 'package:rock_classifier/ModelViews/theme_provider.dart';
import 'package:rock_classifier/ModelViews/user_view_model.dart';
import 'package:rock_classifier/Views/admin/home_page_admin.dart';
import 'package:rock_classifier/Views/admin/information_page_admin.dart';
import 'package:rock_classifier/Views/admin/main_page_admin.dart';
import 'package:rock_classifier/Views/users/home_page_user.dart';
import 'package:rock_classifier/Views/users/login%20_and_regis_widget/login_page.dart';
import 'package:rock_classifier/Views/users/login%20_and_regis_widget/register_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ModelViews/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // khởi tạo đầy đủ các chức năng của Flutter FrameWork
  await Firebase.initializeApp(); // Khỏi tạo firebase trong dự án
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (context) => FirebaseService(),
        ),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Provider cho Themes
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // Provider cho xác minh login
        ChangeNotifierProvider(
          create: (_) => UserViewModel(), // Provider cho hiển thị dùng
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
      home: LoginPage(), // Sử dụng HomeScreen thay vì Scaffold trực tiếp
    );
  }
}
