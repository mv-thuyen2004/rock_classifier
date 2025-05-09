import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/Core/theme/theme.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/ModelViews/auth_provider.dart';
import 'package:rock_classifier/ModelViews/theme_provider.dart';
import 'package:rock_classifier/ModelViews/user_view_model.dart';
import 'package:rock_classifier/Views/users/home_page_user.dart';

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
      home: HomePageUser(), // Sử dụng HomeScreen thay vì Scaffold trực tiếp
    );
  }
}
