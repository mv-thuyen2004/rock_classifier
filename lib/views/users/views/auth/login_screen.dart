import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nckh/viewmodels/login_viewmodel.dart';
import 'package:nckh/views/auth/forgotpassworl_screen.dart';
import 'package:nckh/views/auth/register_screen.dart';
import 'package:nckh/views/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Biến theo dõi trạng thái hiển thị mật khẩu

  void _handleLogin(BuildContext context) async {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    try {
      final user = await loginVM.login(context, email, password);
      if (user != null) {
        // Lưu thông tin đăng nhập vào SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('is_logged_in', true); // Lưu trạng thái đã đăng nhập
        prefs.setString('user_email', email); // Lưu email người dùng
        prefs.setString('user_id', user.uid); // Lưu ID người dùng (nếu có)

        // Chuyển tới màn hình Home sau khi đăng nhập thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoginViewModel>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đăng", style: _titleStyle()),
                Text("Nhập", style: _titleStyle()),
                SizedBox(height: 32),
                _buildTextField(
                    _emailController, "Email của bạn", Icons.person),
                SizedBox(height: 16),
                _buildTextField(
                    _passwordController, "Mật khẩu của bạn", Icons.lock,
                    isPassword: true,
                    isVisible: _isPasswordVisible, toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen()));
                    },
                    child: Text("Quên mật khẩu?", style: _linkStyle()),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF0000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Đăng Nhập", style: _buttonTextStyle()),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()));
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
      ),
    );
  }

  TextStyle _titleStyle() => GoogleFonts.montserrat(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.2,
        letterSpacing: 1.5,
      );

  TextStyle _linkStyle() => GoogleFonts.montserrat(
        fontSize: 14,
        color: Color(0xFFFF0000),
        fontWeight: FontWeight.w500,
      );

  TextStyle _buttonTextStyle() => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  TextStyle _hintTextStyle() => GoogleFonts.montserrat(
        fontSize: 14,
        color: Colors.grey,
      );

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false,
      bool isVisible = false,
      Function()? toggleVisibility}) {
    return TextField(
      controller: controller,
      obscureText: isPassword &&
          !isVisible, // Nếu mật khẩu, sẽ ẩn hoặc hiện theo trạng thái
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget socialLoginButton(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.blue)),
      child: Padding(padding: EdgeInsets.all(8), child: Image.asset(imagePath)),
    );
  }
}
