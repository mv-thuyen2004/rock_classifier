import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/core/define/define.dart';
import 'package:rock_classifier/modelViews/auth_provider.dart';
import 'package:rock_classifier/views/users/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password_2Controller = TextEditingController();

  Future<void> handleRegis() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String email = _emailController.text.trim();
    String pass = _emailController.text.trim();
    String pass_2 = _emailController.text.trim();
    String? error = await authProvider.signUp(email, pass, pass_2);
    if (error == null) {
      debugPrint("ĐĂNG KÍ THÀNH CÔNG !");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } else {
      debugPrint(error.toString());
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
                  child: Text("TẠO \nTÀI KHOẢN ",
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                SizedBox(height: 60),
                inputInAccount(),
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "Bằng cách nhấp vào nút Đăng ký, bạn đồng ý với lời đề nghị công khai",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
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
        onPressed: handleRegis,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          width: double.infinity,
          height: 46,
          child: Center(
            child: Text(
              "ĐĂNG KÍ",
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
        SizedBox(height: 24),
        TextField(
          controller: _password_2Controller,
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
            labelText: "Nhập lại mật khẩu",
            floatingLabelStyle: TextStyle(color: Colors.blue),
            labelStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
