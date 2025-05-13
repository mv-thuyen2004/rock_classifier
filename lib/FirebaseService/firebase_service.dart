import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/Models/user_models.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  // Đăng kí tài khoản
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Đăng nhập tài khoản
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw Exception(e.message ?? 'Đăng nhập thất bại');
      }
      throw Exception('Lỗi không xác định');
    }
  }

  // Đăng xuất tài khoản
  Future<void> signOut() async {
    await _auth.signOut();
  }

// Lấy danh sách người dùng
  Future<List<UserModels>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModels.fromJson({
                ...doc.data(),
                'uid': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách người dùng: $e');
    }
  }

  // lấy ra người dùng theo uid
  Future<UserModels?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final dataWithId = {
          ...doc.data()!,
          'uid': doc.id,
        };
        return UserModels.fromJson(dataWithId);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy người dùng theo ID: $e');
    }
  }

// Cập nhật thông tin người dùng
  Future<void> updateUser(UserModels user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'email': user.email,
        'fullName': user.fullName,
        'address': user.address,
        'avatar': user.avatar,
        'role': user.role,
      });
    } catch (e) {
      throw Exception('Lỗi khi cập nhật người dùng: $e');
    }
  }

// Xóa người dùng
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      final user = _auth.currentUser;
      if (user?.uid == uid) {
        await user?.delete();
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa người dùng: $e');
    }
  }

  // Thêm ảnh => get ra đường link
  Future<String?> uploadAvatar(File image, String uid) async {
    try {
      // Đường dẫn mong muốn : users/{uid}/avatar/avatar.jpg;
      final ref = storage.ref().child('users/$uid/avatar/avatar.jpg');
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Lỗi tải ảnh $e');
      return null;
    }
  }

  // Tìm kiếm người dùng theo email
  Future<List<UserModels>> searchName(String keyword) async {
    try {
      final snapshot =
          await _firestore.collection('users').where('email', isGreaterThanOrEqualTo: keyword).where('email', isLessThanOrEqualTo: '$keyword\uf8ff').get();
      return snapshot.docs
          .map((doc) => UserModels.fromJson(
                doc.data(),
              ))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm người dùng: $e');
    }
  }

  // Thêm người dùng vào Firestore
  Future<void> addUser(UserModels user) async {
    try {
      // Thêm thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'fullName': user.fullName,
        'address': user.address,
        'avatar': user.avatar,
        'role': user.role,
      });
    } catch (e) {
      throw Exception('Lỗi khi thêm người dùng: $e');
    }
  }

  // Lấy role
  Future<String?> getCurrentUserRole() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      return userDoc.data()?['role'] as String?;
    } catch (e) {
      debugPrint('Error getting user role $e');
      return null;
    }
  }

  // Hàm thay đổi mật khẩu
  Future<void> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Lỗi khi đổi mật khẩu: $e');
    }
  }

  // Kiểm tra role
  Future<bool> isAdmin() async => (await getCurrentUserRole()) == 'Admin';
  Future<bool> isSuperClass() async => (await getCurrentUserRole()) == 'Super-Class';
  Future<bool> isUser() async => (await getCurrentUserRole()) == 'User';
}
