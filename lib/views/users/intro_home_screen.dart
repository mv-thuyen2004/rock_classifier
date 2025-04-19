import 'package:flutter/material.dart';
import 'package:rock_classifier/views/users/intro_screen.dart'; // Import màn hình OnboardingScreen

class Intro_HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Intro_HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Tự động chuyển sang OnboardingScreen sau 3 giây với hiệu ứng mượt mà
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  // Hàm tạo hiệu ứng Fade khi chuyển màn hình
  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800), // Thời gian hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) =>
          OnboardingScreen(),
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
              width: 120,
              height: 120,
            ),
            SizedBox(height: 20),
            Text(
              'Xin chào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nghiên cứu khoa học',
              style: TextStyle(
                fontSize: 22,
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
