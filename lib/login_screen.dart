import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rock_classifier/forgotpassworl_screen.dart';
import 'package:rock_classifier/register_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Đăng", style: _titleStyle()),
                  Text("Nhập", style: _titleStyle()),
                ],
              ),
              SizedBox(height: 32),

              //Email Input
              buildTextField(hintText: "Email của bạn", icon: Icons.person),
              SizedBox(height: 16),

              //Password Input
              buildTextField(
                  hintText: "Mật khẩu của bạn",
                  icon: Icons.lock,
                  isPassword: true),
              SizedBox(height: 10),

              //Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ForgotPasswordScreen()), //No transition effect
                    );
                  },
                  child: Text(
                    "Quên mật khẩu?",
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Color(0xFFFF0000),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 20),

              //Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    "Đăng Nhập",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24),

              //Social Login
              Center(
                child: Column(
                  children: [
                    Text("- Hoặc đăng nhập với -",
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialLoginButton("assets/google.png"),
                        SizedBox(width: 16),
                        socialLoginButton("assets/apple.png"),
                        SizedBox(width: 16),
                        socialLoginButton("assets/facebook.png"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              //Register Navigation
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen()), //No transition effect
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                          fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: "Tạo tài khoản mới "),
                        TextSpan(
                          text: "Đăng ký",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Title Style
  TextStyle _titleStyle() {
    return GoogleFonts.montserrat(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.2,
      letterSpacing: 1.5,
      shadows: [
        Shadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(2, 2),
            blurRadius: 2),
      ],
    );
  }

  // ✅ Build TextField
  Widget buildTextField(
      {required String hintText,
      required IconData icon,
      bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 16),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon:
            isPassword ? Icon(Icons.visibility, color: Colors.grey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // ✅ Social Login Buttons
  Widget socialLoginButton(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 1.5)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Image.asset(imagePath),
      ),
    );
  }
}
