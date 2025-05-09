import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nckh/services/auth_error_handler.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<User?> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 🔐 Bước 1: Đăng nhập Firebase Authentication
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        AuthErrorHandler.showStyledDialog(
          context,
          "Lỗi",
          "Đăng nhập không thành công. Vui lòng thử lại.",
        );
        return null;
      }

      // 🔍 Bước 2: Truy vấn dữ liệu người dùng từ Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        AuthErrorHandler.showStyledDialog(
          context,
          "Không tìm thấy thông tin người dùng",
          "Tài khoản tồn tại trong Authentication nhưng không có dữ liệu trong hệ thống.",
        );
        return null;
      }

      final userData = querySnapshot.docs.first.data();

      // 🛑 Bước 3: Kiểm tra trạng thái tài khoản
      if (userData['isDisabled'] == true) {
        AuthErrorHandler.showStyledDialog(
          context,
          "Tài khoản bị khóa",
          "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.",
        );
        return null;
      }

      // 🧾 Bước 4: Kiểm tra quyền truy cập
      final allowedRoles = ['user', 'admin'];
      if (!allowedRoles.contains(userData['role'])) {
        AuthErrorHandler.showStyledDialog(
          context,
          "Không có quyền truy cập",
          "Bạn không có quyền đăng nhập bằng tài khoản này.",
        );
        return null;
      }

      return user;
    } on FirebaseAuthException catch (e) {
      AuthErrorHandler.showAuthError(context, e);
      return null;
    } catch (e) {
      AuthErrorHandler.showStyledDialog(context, "Lỗi", e.toString());
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
