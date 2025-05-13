import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_view_model.dart';
import 'package:rock_classifier/Models/user_models.dart';

class EditUserInfoBottomSheet extends StatefulWidget {
  final UserModels user;

  const EditUserInfoBottomSheet({super.key, required this.user});

  @override
  State<EditUserInfoBottomSheet> createState() =>
      _EditUserInfoBottomSheetState();
}

class _EditUserInfoBottomSheetState extends State<EditUserInfoBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.user.fullName ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      bool success = await authViewModel.updateUserInfo(
        fullName: _fullNameController.text,
        address: _addressController.text,
      );

      Navigator.of(context).pop(); // Close loading

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thành công!')),
        );
        Navigator.of(context).pop(); // Close bottom sheet
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thất bại!')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
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
              'Chỉnh sửa thông tin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _fullNameController,
              label: 'Họ và tên',
              validator: (val) =>
                  val == null || val.isEmpty ? 'Vui lòng nhập họ và tên' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(controller: _addressController, label: 'Địa chỉ'),
            const SizedBox(height: 20),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _updateUserInfo(authViewModel),
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Lưu thay đổi',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// Hàm mở BottomSheet có animation mượt
void showEditUserInfoBottomSheet(BuildContext context, UserModels user) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Edit Info',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink(); // Bắt buộc phải có
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: EditUserInfoBottomSheet(user: user),
            ),
          ),
        ),
      );
    },
  );
}
