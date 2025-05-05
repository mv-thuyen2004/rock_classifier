import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordAdmin extends StatefulWidget {
  const UpdatePasswordAdmin({super.key});

  @override
  State<UpdatePasswordAdmin> createState() => _UpdatePasswordAdminState();
}

class _UpdatePasswordAdminState extends State<UpdatePasswordAdmin> {
  TextEditingController _passOldController = TextEditingController();
  TextEditingController _passNewController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();

  Future<void> updatePassword(String oldPass, String newPass) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Người dùng chưa đăng nhập");
      return;
    }
    final cred =
        EmailAuthProvider.credential(email: user.email!, password: oldPass);
    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPass);
      print("Đổi mật khẩu thành công !");
    } catch (e) {
      print("Lỗi : $e");
    }
  }

  void handlePass() async {
    final oldPass = _passConfirmController.text.trim();
    final newPass = _passNewController.text.trim();
    final confirmPass = _passConfirmController.text.trim();
    if (newPass != confirmPass) {
      return;
    }
    await updatePassword(oldPass, newPass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Thay đổi mật khẩu",
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                controller: _passOldController,
                decoration: InputDecoration(
                  hintText: "Mật khẩu cũ của bạn",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passNewController,
                decoration: InputDecoration(
                  hintText: "Mật khẩu mới của bạn",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passConfirmController,
                decoration: InputDecoration(
                  hintText: "Xác nhận lại mật khẩu của bạn",
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  handlePass();
                },
                child: Text(
                  "Xác nhận",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
