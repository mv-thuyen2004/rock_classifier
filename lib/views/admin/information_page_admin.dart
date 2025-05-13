import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_information_admin.dart';

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
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 36,
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
                const SizedBox(height: 12),
                Text(
                  user.fullName ?? "User Name",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email ?? "user@example.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 24,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
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
                        leading: const Icon(Icons.edit, color: Colors.teal),
                        title: Text(
                          "Chỉnh sửa thông tin cá nhân",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_outlined, color: Colors.teal),
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
                        leading: const Icon(Icons.language, color: Colors.teal),
                        title: Text(
                          "Chuyển sang ngôn ngữ Tiếng Anh",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_outlined, color: Colors.teal),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng đang phát triển')),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ListTile(
                        leading: const Icon(Icons.wb_sunny, color: Colors.teal),
                        title: Text(
                          "Chuyển sang giao diện sáng",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_outlined, color: Colors.teal),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      await authViewModel.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
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
