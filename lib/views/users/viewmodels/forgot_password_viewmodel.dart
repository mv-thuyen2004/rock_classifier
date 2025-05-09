// lib/view_models/forgot_password_view_model.dart
import 'package:flutter/material.dart';
import 'package:nckh/models/forgot_password_model.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  TextEditingController emailController =
      TextEditingController(); // Controller để quản lý email nhập vào

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ForgotPasswordModel _forgotPasswordModel = ForgotPasswordModel();

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text
        .trim(); // Lấy email từ controller và loại bỏ khoảng trắng thừa
    if (email.isEmpty) {
      // Nếu email trống, hiển thị thông báo lỗi
      _errorMessage = 'Email không được để trống';
      notifyListeners();

      // Hiển thị Snackbar thông báo email trống
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập địa chỉ email của bạn!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _forgotPasswordModel.sendResetEmail(email);
      _errorMessage = null; // Reset error message after successful request

      // Hiển thị Snackbar thông báo đã gửi email thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Đã gửi thông báo qua email, hãy kiểm tra hộp thư đến của bạn!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _errorMessage = e.toString();

      // Hiển thị thông báo lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã xảy ra lỗi: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
