import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';

class UpdatePasswordAdmin extends StatefulWidget {
  const UpdatePasswordAdmin({super.key});

  @override
  State<UpdatePasswordAdmin> createState() => _UpdatePasswordAdminState();
}

class _UpdatePasswordAdminState extends State<UpdatePasswordAdmin> {
  final TextEditingController _passOldController = TextEditingController();
  final TextEditingController _passNewController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();

  Future<void> _handlePass(BuildContext context) async {
    final oldPass = _passOldController.text.trim();
    final newPass = _passNewController.text.trim();
    final confirmPass = _passConfirmController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ các trường')),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới phải có ít nhất 6 ký tự')),
      );
      return;
    }

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final error = await authViewModel.updatePassword(oldPass, newPass);
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
            centerTitle: true,
            title: const Text(
              "Thay đổi mật khẩu",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _passOldController,
                            decoration: InputDecoration(
                              hintText: "Mật khẩu cũ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passNewController,
                            decoration: InputDecoration(
                              hintText: "Mật khẩu mới",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passConfirmController,
                            decoration: InputDecoration(
                              hintText: "Xác nhận mật khẩu mới",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2,
                              ),
                              onPressed: authViewModel.isLoading ? null : () => _handlePass(context),
                              child: const Text(
                                "Xác nhận",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (authViewModel.isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _passOldController.dispose();
    _passNewController.dispose();
    _passConfirmController.dispose();
    super.dispose();
  }
}
