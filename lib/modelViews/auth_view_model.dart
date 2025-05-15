import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/Models/user_models.dart';
import 'dart:io';

import 'package:rock_classifier/Views/admin/main_page_admin.dart';
import 'package:rock_classifier/Views/users/home_page_user.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserModels? _currentUser;
  UserModels? get currentUser => _currentUser;

  String? _currentUserRole;
  String? get currentUserRole => _currentUserRole;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<UserModels?> getCurrentUser() async {
    final firebaseUser = _firebaseService.auth.currentUser;
    if (firebaseUser != null) {
      return await _firebaseService.getUserById(firebaseUser.uid);
    }
    return null;
  }

  AuthViewModel() {
    _firebaseService.auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        _currentUser = await _firebaseService.getUserById(firebaseUser.uid);
        _currentUserRole = await _firebaseService.getCurrentUserRole();
      } else {
        _currentUser = null;
        _currentUserRole = null;
      }
      notifyListeners();
    });
  }

  // Đăng nhập
  Future<String?> signIn(BuildContext context, String email, String password) async {
    _setLoading(true);
    try {
      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _firebaseService.getUserById(firebaseUser.uid);
        _currentUserRole = await _firebaseService.getCurrentUserRole();

        if (_currentUserRole == null) {
          _errorMessage = 'Không tìm thấy vai trò của người dùng';
          _setLoading(false);
          notifyListeners();
          return _errorMessage;
        }

        _setLoading(false);
        notifyListeners();

        if (isAdmin() || isSuperUser()) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPageAdmin(),
              ));
        } else if (isUser()) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageUser(),
              ));
        } else {
          _errorMessage = 'Vai trò không hợp lệ';
          notifyListeners();
          return _errorMessage;
        }
        _errorMessage = null;
        return null;
      } else {
        _errorMessage = 'Không thể lấy thông tin người dùng';
        _setLoading(false);
        notifyListeners();
        return _errorMessage;
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleFirebaseAuthError(e);
      _setLoading(false);
      notifyListeners();
      return _errorMessage;
    } catch (e) {
      _errorMessage = 'Lỗi không xác định: $e';
      _setLoading(false);
      notifyListeners();
      return _errorMessage;
    }
  }

  // Đăng kí
  Future<String?> signUp(String email, String password, String password2) async {
    if (password != password2) {
      return "Mật khẩu không khớp!";
    }
    try {
      UserCredential result = await _firebaseService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        UserModels newUser = UserModels(
          uid: user.uid,
          fullName: null,
          address: null,
          email: email,
          avatar: null,
          role: "User",
          createdAt: DateTime.now(),
        );
        await _firebaseService.firestore.collection('users').doc(user.uid).set(newUser.toJson());
        _currentUser = newUser;
        _currentUserRole = newUser.role;
        notifyListeners();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthError(e);
    } catch (e) {
      return 'Lỗi không xác định: $e';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseService.auth.signOut();
    _currentUser = null;
    _currentUserRole = null;
    notifyListeners();
  }

  // Cập nhật ngườu dùng
  Future<void> updateUser(UserModels user) async {
    try {
      _setLoading(true);
      await _firebaseService.updateUser(user);
      _currentUser = user;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật thông tin: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Tải ảnh lên ứng dụng
  Future<String?> uploadAvatar(File image) async {
    try {
      _setLoading(true);
      final uid = _firebaseService.auth.currentUser?.uid;
      if (uid == null) {
        _errorMessage = 'Không tìm thấy người dùng !';
        notifyListeners();
        return null;
      }

      final url = await _firebaseService.uploadAvatar(image, uid);
      if (url != null && _currentUser != null) {
        await updateUser(_currentUser!.copyWith(avatar: url));
      }
      return url;
    } catch (e) {
      _errorMessage = 'Lỗi tải ảnh : $e';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // update trạng thái isLoading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
      case 'operation-not-allowed':
        return 'Chức năng đăng ký bị vô hiệu hóa';
      case 'network-request-failed':
        return 'Không có kết nối mạng';
      case 'user-not-found':
      case 'wrong-password':
        return 'Email hoặc mật khẩu không đúng';
      default:
        return 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  Future<String?> updatePassword(String oldPassword, String newPassword) async {
    try {
      _setLoading(true);
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        _errorMessage = 'Người dùng chưa đăng nhập';
        notifyListeners();
        return _errorMessage;
      }
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      _errorMessage = null;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleFirebaseAuthError(e);
      notifyListeners();
      return _errorMessage;
    } catch (e) {
      _errorMessage = 'Lỗi không xác định: $e';
      notifyListeners();
      return _errorMessage;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUserInfo({
    required String fullName,
    required String address,
  }) async {
    try {
      _setLoading(true);
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) {
        _errorMessage = 'Người dùng chưa đăng nhập';
        notifyListeners();
        return false;
      }

      // Cập nhật thông tin người dùng trong Firestore
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(
          fullName: fullName.isEmpty ? null : fullName,
          address: address.isEmpty ? null : address,
        );
        await _firebaseService.updateUser(updatedUser);
        _currentUser = updatedUser;
      }

      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật thông tin: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  bool isAdmin() => _currentUserRole == 'Admin';
  bool isSuperUser() => _currentUserRole == 'Super-User';
  bool isUser() => _currentUserRole == 'User';
}
