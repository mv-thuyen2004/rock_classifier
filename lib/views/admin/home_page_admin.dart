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
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Xin chào Admin',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.orange,
                          backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                          child: user.avatar == null
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rowInfo(label: 'email', value: user.email ?? 'Bạn chưa có email'),
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
                      Icon(Icons.grid_view_rounded, color: Colors.orange[900]),
                      const SizedBox(width: 10),
                      Text(
                        'Chức Năng',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  functionButton(
                    title: 'Quản lí tài khoản người dùng ',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDataManagement(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  functionButton(
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
                  functionButton(
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

class rowInfo extends StatelessWidget {
  final String label;
  final String value;

  const rowInfo({required this.label, required this.value});

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

// ignore: must_be_immutable
class functionButton extends StatelessWidget {
  final String title;
  VoidCallback onTap;

  functionButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // Thêm hành động khi nhấn vào
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[50]!, Colors.orange[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          title: GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.orange[900],
            size: 20,
          ),
        ),
      ),
    );
  }
}
