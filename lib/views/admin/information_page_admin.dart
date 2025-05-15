import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_information_admin.dart';
import 'package:rock_classifier/Views/admin/function/function_interface/interface_language/language_screen.dart';
import 'package:rock_classifier/Views/users/login_and_regis_widget/login_page.dart';

class InformationPageAdmin extends StatelessWidget {
  const InformationPageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Kiểm tra trạng thái
        if (authViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (authViewModel.currentUser == null) {
          return const Center(child: Text('Không tìm thấy thông tin người dùng'));
        }

        final user = authViewModel.currentUser!;
        return Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Thông tin người dùng',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal.shade100,
                  backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                  child: user.avatar == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.teal,
                        )
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  user.fullName ?? "Bạn chưa đặt tên",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit, color: Colors.grey),
                        title: Text(
                          "Chỉnh sửa thông tin cá nhân",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateInformationAdmin(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ListTile(
                        leading: const Icon(Icons.language, color: Colors.grey),
                        title: Text(
                          "Chuyển sang ngôn ngữ Tiếng Anh",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LanguageScreen(),
                              ));
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ListTile(
                        leading: const Icon(Icons.wb_sunny, color: Colors.grey),
                        title: Text(
                          "Chuyển sang giao diện sáng",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng đang phát triển')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      await authViewModel.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: Text(
                      "Đăng xuất",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
