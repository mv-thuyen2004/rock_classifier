import 'package:flutter/material.dart';
import 'package:nckh/views/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nckh/views/intro/intro_screen.dart';
import 'package:nckh/views/auth/login_screen.dart';

class Intro_HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Intro_HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppUsage();
  }

  // Kiểm tra người dùng đã sử dụng ứng dụng chưa, và tình trạng đăng nhập
  Future<void> _checkAppUsage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy giá trị từ SharedPreferences, mặc định là true cho lần đầu sử dụng
    bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    // Kiểm tra trạng thái đăng nhập từ SharedPreferences, mặc định là false
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    // Nếu là lần đầu sử dụng ứng dụng
    if (isFirstTime) {
      // Sau 3 giây chuyển đến OnboardingScreen
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(_createRoute(OnboardingScreen()));
      });

      // Cập nhật trạng thái ứng dụng đã được sử dụng
      prefs.setBool('is_first_time', false);
    } else {
      // Nếu đã đăng nhập, chuyển thẳng vào HomeScreen
      if (isLoggedIn) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(_createRoute(HomeScreen()));
        });
      } else {
        // Nếu chưa đăng nhập, chuyển đến LoginScreen
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(_createRoute(LoginScreen()));
        });
      }
    }
  }

  // Hàm tạo hiệu ứng Fade khi chuyển màn hình
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800), // Thời gian hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation, // Hiệu ứng mờ dần
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 160,
              height: 160,
            ),
            SizedBox(height: 20),
            Text(
              'Xin chào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nghiên cứu khoa học',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nhận dạng đá, đá, pha lê độc quyền của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
