import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/core/define/define.dart';
import 'package:rock_classifier/modelViews/auth_provider.dart';
import 'package:rock_classifier/modelViews/login_firebase_auth_provider.dart';
import 'package:rock_classifier/views/admin/home_page_admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginFirebaseAuthProvider authLogin = LoginFirebaseAuthProvider();

  void handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();

    String? error = await authProvider.signIn(email, pass);
    if (error == null) {
      debugPrint("ĐĂNG NHẬP THÀNH CÔNG !");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageAdmin(),
          ));
    } else {
      debugPrint("ERROR : ${error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: WIDGET_ALL),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 100),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text("ĐĂNG \nNHẬP",
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                SizedBox(height: 60),
                inputInAccount(),
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    "Quên mật khẩu ?",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
                buttonSignIn(),
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "- Hoặc đăng nhập với -",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          socialButton("assets/images/apple.png"),
                          socialButton("assets/images/facebook.png"),
                          socialButton("assets/images/google.png"),
                        ],
                      ),
                      SizedBox(height: 30),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Tạo tài khoản mới ",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                        TextSpan(
                            text: "ĐĂNG KÍ",
                            style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2))
                      ]))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Image.asset(imagePath),
    );
  }

  Widget buttonSignIn() {
    return TextButton(
        onPressed: handleLogin,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          width: double.infinity,
          height: 46,
          child: Center(
            child: Text(
              "SIGN IN",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ));
  }

  Widget inputInAccount() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            labelText: "Email của bạn",
            floatingLabelStyle: TextStyle(color: Colors.blue),
            labelStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(height: 24),
        TextField(
          controller: _passwordController,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.remove_red_eye,
              color: Colors.grey,
            ),
            prefixIcon: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            labelText: "Mât khẩu của bạn",
            floatingLabelStyle: TextStyle(color: Colors.blue),
            labelStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
