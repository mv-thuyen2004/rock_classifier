import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/Core/theme/theme.dart';
import 'package:rock_classifier/FirebaseService/firebase_news_service.dart';
import 'package:rock_classifier/FirebaseService/firebase_rock_service.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/ModelViews/news_view_model.dart';
import 'package:rock_classifier/ModelViews/rock_view_model.dart';
import 'package:rock_classifier/ModelViews/user_list_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_interface/interface_language/language_screen.dart';
import 'package:rock_classifier/Views/users/login_and_regis_widget/login_page.dart';
import 'package:rock_classifier/ModelViews/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart'; // Thêm thư viện easy_localization

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Khởi tạo đầy đủ các chức năng của Flutter Framework
  await Firebase.initializeApp(); // Khởi tạo Firebase trong dự án
  await EasyLocalization.ensureInitialized(); // Khởi tạo easy_localization

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('vi'), Locale('en')], // Các ngôn ngữ hỗ trợ
      path: 'assets/translations', // Đường dẫn đến file dịch
      child: MultiProvider(
        providers: [
          Provider<FirebaseService>(
            create: (context) => FirebaseService(),
          ),
          Provider(
            create: (context) => FirebaseRockService(),
          ),
          Provider(
            create: (context) => FirebaseNewsService(),
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider()), // Provider cho Themes
          ChangeNotifierProvider(create: (_) => RockViewModel()), // Provider cho hiển thị đá
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => UserListViewModel()),
          ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale, // Sử dụng ngôn ngữ mặc định của thiết bị
      theme: brownTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
