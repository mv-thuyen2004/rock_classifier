import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nckh/viewmodels/register_viewmodel.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false; // Biến theo dõi trạng thái hiển thị mật khẩu
  bool _isConfirmPasswordVisible =
      false; // Biến theo dõi trạng thái hiển thị mật khẩu xác nhận

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
                Text("Tạo", style: _titleStyle()),
                Text("Tài Khoản", style: _titleStyle()),
                SizedBox(height: 32),
                _buildTextField(
                    "Tên tài khoản Email", Icons.person, emailController),
                SizedBox(height: 16),
                _buildTextField("Mật khẩu", Icons.lock, passwordController,
                    isPassword: true,
                    isVisible: _isPasswordVisible, toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                SizedBox(height: 16),
                _buildTextField(
                    "Nhập Lại Mật Khẩu", Icons.lock, confirmPasswordController,
                    isPassword: true,
                    isVisible: _isConfirmPasswordVisible, toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
                SizedBox(height: 12),
                _termsAndConditionsText(),
                SizedBox(height: 24),
                _buildRegisterButton(context),
                SizedBox(height: 24),
                _buildLoginRedirect(context),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            blurRadius: 2)
      ],
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, TextEditingController controller,
      {bool isPassword = false,
      bool isVisible = false,
      Function()? toggleVisibility}) {
    return TextField(
      controller: controller,
      obscureText: isPassword &&
          !isVisible, // Nếu mật khẩu, sẽ ẩn hoặc hiện theo trạng thái
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
        prefixIcon: Icon(icon, color: Color(0xFF626262)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: Color(0xFF626262),
                ),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _termsAndConditionsText() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[900]),
        children: [
          TextSpan(text: "Bằng cách nhấp vào nút "),
          TextSpan(
            text: "Đăng ký",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, color: Colors.red),
          ),
          TextSpan(text: ", bạn đồng ý với điều khoản của ứng dụng!"),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () {
                    viewModel.registerUser(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      confirmPasswordController.text.trim(),
                      context,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF0000),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: viewModel.isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Đăng Ký",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
          ),
        );
      },
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
