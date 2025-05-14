import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_main/rock_data_management/view/rock_list_screen.dart';
import 'package:rock_classifier/Views/admin/function/function_main/user_data_management/View/user_data_management.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Trang chủ Admin',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Thông tin người dùng',
                        style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Avatar nền
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.grey,
                                child: user.avatar == null
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40,
                                      )
                                    : null,
                              ),
                              // Nếu có avatar, tải ảnh từ mạng
                              if (user.avatar != null)
                                ClipOval(
                                  child: Image.network(
                                    user.avatar!,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error, color: Colors.white);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rowInfo(label: 'Email', value: user.email),
                              rowInfo(
                                label: 'Tên người dùng',
                                value: user.fullName ?? 'Bạn chưa có tên',
                              ),
                              rowInfo(label: 'Địa chỉ', value: user.address ?? 'Bạn chưa có địa chỉ'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Chức Năng',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  FunctionButton(
                    title: 'Quản lí tài khoản người dùng ',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDataManagement(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FunctionButton(
                    title: 'Dữ liệu cơ sở trong ứng dụng',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RockListScreen(),
                          ));
                    },
                  ),
                  SizedBox(height: 16),
                  FunctionButton(
                    title: 'Quản lí bài viết',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: camel_case_types
class rowInfo extends StatelessWidget {
  final String label;
  final String value;

  const rowInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.orange[900],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FunctionButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        color: Colors.white, // thêm màu nền nếu cần
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
