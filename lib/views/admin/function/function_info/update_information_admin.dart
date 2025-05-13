import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Models/user_models.dart';
import 'package:rock_classifier/Views/admin/function/function_info/edit_user_info_bottom_sheet.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_password_admin/update_password_admin.dart';

class UpdateInformationAdmin extends StatefulWidget {
  const UpdateInformationAdmin({super.key});

  @override
  State<UpdateInformationAdmin> createState() => _UpdateInformationAdminState();
}

class _UpdateInformationAdminState extends State<UpdateInformationAdmin> {
  // Hàm xử lí hình ảnh (đã chọn phương thức)
  Future<void> _pickImage(UserModels user) async {
    final source = await _selectedImageSource();
    if (source == null) return;

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    final url = await authViewModel.uploadAvatar(File(pickedFile.path));
    //  Tắt loading
    Navigator.of(context).pop();
    if (url != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã cập nhật ảnh thành công !"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm ảnh không thành công !"),
        ),
      );
    }
  }

  //  Hàm lấy ra lựa chọn
  Future<ImageSource?> _selectedImageSource() async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Chọn nguồn ảnh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Máy ảnh'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            )
          ],
        ),
      ),
    );
  }

  // WIDGET _buildListTile;
  Widget _buildListTile({required String title, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF0F0F0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = authViewModel.currentUser;
        if (user == null) {
          return const Center(child: Text('Không tìm thấy thông tin người dùng'));
        }

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
              "Thông tin người dùng",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    showEditUserInfoBottomSheet(context, user);
                  },
                  child: const Text("Chỉnh sửa"),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(user),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.teal.shade100,
                          backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                          child: user.avatar == null ? const Icon(Icons.person, size: 40, color: Colors.teal) : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Thay đổi ảnh đại diện", style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Personal Info
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        title: "Họ và tên",
                        value: user.fullName ?? 'Chưa cập nhật',
                        onTap: () {},
                      ),
                      _buildListTile(
                        title: "Địa chỉ",
                        value: user.address ?? 'Chưa cập nhật',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Email and Password
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Tài khoản và mật khẩu", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        title: "Địa chỉ Email",
                        value: user.email ?? 'Chưa cập nhật',
                        onTap: () {},
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdatePasswordAdmin(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Mật khẩu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Text("Thay đổi mật khẩu", style: TextStyle(fontSize: 16, color: Colors.teal.shade800)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
