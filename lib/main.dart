import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/Core/theme/theme.dart';
import 'package:rock_classifier/FirebaseService/firebase_rock_service.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/ModelViews/rock_view_model.dart';
import 'package:rock_classifier/ModelViews/user_list_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_main/rock_data_management/view/rock_list_screen.dart';
import 'package:rock_classifier/Views/admin/function/function_main/user_data_management/View/user_data_management.dart';
import 'package:rock_classifier/Views/users/login_and_regis_widget/login_page.dart';
import 'package:rock_classifier/Views/users/login_and_regis_widget/register_page.dart';

import 'ModelViews/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // khởi tạo đầy đủ các chức năng của Flutter FrameWork
  await Firebase.initializeApp(); // Khỏi tạo firebase trong dự án
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (context) => FirebaseService(),
        ),
        Provider(
          create: (context) => FirebaseRockService(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Provider cho Themes
        ChangeNotifierProvider(
          create: (_) => RockViewModel(), // Provider cho hiển thị dùng
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserListViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: brownTheme,
      debugShowCheckedModeBanner: false,
      home: UserDataManagement(), // Sử dụng HomeScreen thay vì Scaffold trực tiếp
    );
  }
}
