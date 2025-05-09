import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nckh/services/auth_error_handler.dart';
import 'package:nckh/views/auth/login_screen.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> registerUser(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showInlineError(context, "Vui lòng điền đầy đủ thông tin");
      return;
    }

    if (password != confirmPassword) {
      _showInlineError(context, "Mật khẩu không trùng khớp");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email)) {
      _showInlineError(context, "Email không hợp lệ");
      return;
    }

    if (password.length < 6) {
      _showInlineError(context, "Mật khẩu phải có ít nhất 6 ký tự");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      // Kiểm tra email đã tồn tại trong Firebase Auth
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        AuthErrorHandler.showStyledDialog(
            context, "Lỗi đăng ký", "Email đã được sử dụng để đăng ký.");
        return;
      }

      // Kiểm tra email đã tồn tại trong Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        AuthErrorHandler.showStyledDialog(
            context, "Lỗi đăng ký", "Email đã được sử dụng để đăng ký.");
        return;
      }

      // Đăng ký người dùng
      final userModel = await _authService.registerWithEmail(email, password);

      if (userModel != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } else {
        AuthErrorHandler.showStyledDialog(
          context,
          "Lỗi",
          "Không thể đăng ký người dùng. Vui lòng thử lại.",
        );
      }
    } on FirebaseAuthException catch (e) {
      AuthErrorHandler.showAuthError(context, e);
    } catch (e) {
      AuthErrorHandler.showStyledDialog(
          context, "Lỗi", "Đã xảy ra lỗi không xác định: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showInlineError(BuildContext context, String message) {
    AuthErrorHandler.showStyledDialog(context, "Lỗi đăng ký", message);
  }
}
