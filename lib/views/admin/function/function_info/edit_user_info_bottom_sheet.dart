import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Models/user_models.dart';

void editUserInfoBottomSheet(BuildContext context, UserModels user) {
  final fullNameController = TextEditingController(text: user.fullName ?? '');
  final addressController = TextEditingController(text: user.address ?? '');
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                'Chỉnh sửa thông tin cá nhân',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ và tên' : null,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  labelStyle: const TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  labelStyle: const TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // show circularProgress
                      }
                      final updateUser = UserModels(
                        uid: user.uid,
                        email: user.email,
                        role: user.role,
                        createdAt: user.createdAt,
                        fullName: fullNameController.text.trim(),
                        address: addressController.text.trim(),
                        avatar: user.avatar,
                      );

                      await authViewModel.updateUser(updateUser);
                      Navigator.of(context).pop();
                      if (authViewModel.errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cập nhật thông tin người dùng thành công !'),
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Không thành công ! ${authViewModel.errorMessage}'),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
