import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/Models/user_models.dart';
import 'package:rock_classifier/Views/admin/function/function_main/user_data_management/View/user_data_management.dart';

class UserListViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<UserModels> _users = [];
  List<UserModels> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  UserModels? _selectedUser;
  UserModels? get selectedUser => _selectedUser;

  // Lấy tất cả người dùng
  Future<void> fetchUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _firebaseService.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print('DU LIEU TRONG USER_LIST_VIEW ${_users.length}');
    }
  }

  Future<void> updateUser(UserModels user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firebaseService.updateUser(user);
      await fetchUser(); // Cập nhật lại danh sách người dùng nếu cần
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nht người dùng kèm hình ảnh mới
  Future<void> updateUserWithImage(UserModels user, File image) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final url = await _firebaseService.uploadAvatar(image, user.uid);
      if (url != null) {
        user.avatar = url;
      }
      await _firebaseService.updateUser(user);
      await fetchUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa người dùng
  Future<void> deleteUser(UserModels user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _firebaseService.deleteUser(user.uid);
      _users.removeWhere(
        (u) => u.uid == user.uid,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tìm kiếm người dùng theo email
  Future<void> searchUsers(String keyword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _firebaseService.searchName(keyword);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Lấy người dùng theo UID
  Future<void> getUserById(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _selectedUser = await _firebaseService.getUserById(uid);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> addUserWithoutAvatar(UserModels user) async {
    try {
      UserCredential result = await _firebaseService.createUserWithEmailAndPassword(
        email: user.email,
        password: 'tnanh1407', // Có thể thay bằng mật khẩu nhập từ form
      );

      user.uid = result.user!.uid;

      await _firebaseService.addUser(user);

      notifyListeners();
    } catch (e) {
      throw Exception('Lỗi khi thêm người dùng (không có ảnh): $e');
    }
  }

  Future<void> addUserWithAvatar(UserModels user, File image) async {
    try {
      UserCredential result = await _firebaseService.createUserWithEmailAndPassword(email: user.email, password: 'tnanh1407');

      user.uid = result.user!.uid;

      final avatarUrl = await _firebaseService.uploadAvatar(image, user.uid);

      if (avatarUrl != null) {
        user.avatar = avatarUrl;

        await _firebaseService.addUser(user);

        notifyListeners();
      } else {
        throw Exception('Không thể tải ảnh lên Firebase Storage');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm người dùng (có ảnh): $e');
    }
  }

  // Sắp xếp danh sách người dùng
  void sortUsers(SortOption option) {
    switch (option) {
      case SortOption.createdAt:
        _users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.role:
        _users.sort((a, b) => a.role.compareTo(b.role));
        break;
      case SortOption.name:
        _users.sort((a, b) => a.email.compareTo(b.email));
        break;
    }
    notifyListeners();
  }
}
