import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/core/widgets/password_Field.dart';
import 'package:rock_classifier/ModelViews/auth_provider.dart';
import 'package:rock_classifier/Views/users/login%20_and_regis_widget/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void handleCreateAccount(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? error = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _confirmPasswordController.text.trim(),
    );

    if (error == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => InfoDialog(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          title: "Đăng kí thành công",
          message:
              "Chúc mừng bạn đã tạo tài khoản thành công. \n Nhấn 'Xác nhận' để tiếp tục.",
          buttonColor: Colors.green,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => InfoDialog(
          icon: Icons.error_outline,
          iconColor: Colors.redAccent,
          title: "Đăng kí thành công",
          message: error,
          buttonColor: Colors.redAccent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Đăng kí",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Email của bạn",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                PasswordField(
                    controller: _passwordController,
                    title: "Nhập mật khẩu của bạn"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                PasswordField(
                    controller: _confirmPasswordController,
                    title: "Xác nhận lại mật khẩu"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    children: const [
                      TextSpan(
                          text:
                              "Bằng cách nhấp vào nút đăng kí, bạn đồng ý với"),
                      TextSpan(
                        text: " Điều khoản dịch vụ",
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(text: " và "),
                      TextSpan(
                        text: "Chính sách bảo mật",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                ElevatedButton(
                  onPressed: () {
                    handleCreateAccount(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Đăng kí"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "- Hoặc là đăng nhập với -",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.android,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.apple,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.facebook,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Bạn đã có tài khoản ? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.brown,
                      ),
                      child: const Text("Đăng nhập"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final Color buttonColor;
  final VoidCallback onPressed;
  const InfoDialog(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.message,
      required this.buttonColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 16, color: Colors.black87, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
