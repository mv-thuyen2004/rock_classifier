import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rock_classifier/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  //Convert to StatefulWidget
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // Title "Tạo Tài Khoản"
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tạo", style: _titleStyle()),
                    Text("Tài Khoản", style: _titleStyle()),
                  ],
                ),
                SizedBox(height: 32),

                // Input Fields
                buildTextField(
                    hintText: "Tên tài khoản Email", icon: Icons.person),
                SizedBox(height: 16),
                buildTextField(
                    hintText: "Mật khẩu", icon: Icons.lock, isPassword: true),
                SizedBox(height: 16),
                buildTextField(
                    hintText: "Nhập Lại Mật Khẩu",
                    icon: Icons.lock,
                    isPassword: true),
                SizedBox(height: 12),

                //Terms & Conditions
                termsAndConditionsText(),
                SizedBox(height: 24),

                //Register Button
                buildRegisterButton(),
                SizedBox(height: 24),

                //Social Login
                buildSocialLogin(),
                SizedBox(height: 24),

                //Login Redirect
                buildLoginRedirect(),

                SizedBox(height: 40),
              ],
            ),
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
        prefixIcon: Icon(icon, color: Color(0xFF626262)),
        suffixIcon: isPassword
            ? Icon(Icons.visibility, color: Color(0xFF626262))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // ✅ Terms & Conditions Text
  Widget termsAndConditionsText() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[800]),
        children: [
          TextSpan(text: "Bằng cách nhấp vào nút "),
          TextSpan(
            text: "Đăng ký",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, color: Colors.red),
          ),
          TextSpan(text: ", bạn đồng ý với điều khoản của ứng dụng !"),
        ],
      ),
    );
  }

  // ✅ Register Button
  Widget buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFF0000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          "Đăng Ký",
          style: GoogleFonts.montserrat(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  // ✅ Social Login
  Widget buildSocialLogin() {
    return Column(
      children: [
        Text("- Hoặc tiếp tục với -",
            style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
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
    );
  }

  // ✅ Login Redirect
  Widget buildLoginRedirect() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen()), // 🔥 No transition effect
          );
        },
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black),
            children: [
              TextSpan(text: "Bạn đã có sẵn tài khoản? "),
              TextSpan(
                text: "Đăng nhập",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
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
