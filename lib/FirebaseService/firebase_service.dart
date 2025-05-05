import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rock_classifier/Models/user_models.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mật khẩu mặc định cho người dùng mới
  static const String defaultPassword = 'tnanh1407';

  //Lấy 1 người dùng theo Uid
  Stream<UserModels?> getUserById(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map(
      (doc) {
        if (doc.exists) {
          return UserModels.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        } else {
          return null;
        }
      },
    );
  }

  // Lấy tất cả người dùng (không phân trang, giữ lại cho các mục đích khác)
  Stream<List<UserModels>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModels.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Lấy người dùng theo trang
  Future<Map<String, dynamic>> getUsersPaginated({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final users = snapshot.docs
          .map((doc) =>
              UserModels.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      final newLastDocument =
          snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return {
        'users': users,
        'lastDocument': newLastDocument,
      };
    } catch (e) {
      debugPrint('Error getting paginated users: $e');
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getActionLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('action_logs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getSearchLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('search_logs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addUser(UserModels user) async {
    try {
      // Kiểm tra vai trò của người dùng hiện tại
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      final currentUserRole = currentUserDoc.data()?['role'] as String?;
      if (currentUserRole == 'Super-Class' && user.role == 'Admin') {
        throw Exception(
            'Super-Class không thể thêm người dùng với vai trò Admin');
      }

      // Tạo tài khoản Firebase Authentication với mật khẩu mặc định
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.gmail!,
        password: defaultPassword,
      );

      // Cập nhật UID của người dùng mới
      final userWithUid = user.copyWith(uid: userCredential.user!.uid);
      final userWithTimestamp = userWithUid.copyWith(
          createdAt: userWithUid.createdAt ?? DateTime.now());

      // Lưu thông tin người dùng vào Firestore
      await _firestore
          .collection('users')
          .doc(userWithUid.uid)
          .set(userWithTimestamp.toMap());

      // Ghi log hành động
      if (currentUserRole == 'Admin' || currentUserRole == 'Super-Class') {
        await addActionLog(
            userWithUid.uid as String, 'Add', 'Thêm người dùng: ${user.gmail}');
      }
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModels user) async {
    try {
      // Kiểm tra vai trò của người dùng hiện tại
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      final currentUserRole = currentUserDoc.data()?['role'] as String?;
      final targetUserDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final targetUserRole = targetUserDoc.data()?['role'] as String?;

      if (currentUserRole == 'Super-Class' && targetUserRole == 'Admin') {
        throw Exception('Super-Class không thể chỉnh sửa người dùng Admin');
      }
      if (currentUserRole == 'Super-Class' && user.role == 'Admin') {
        throw Exception('Super-Class không thể gán vai trò Admin');
      }

      final currentRole = targetUserDoc.data()?['role'] as String?;
      final newRole = user.role;

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      if (currentRole != newRole) {
        if (newRole == 'Admin' || newRole == 'Super-Class') {
          await addActionLog(user.uid as String, 'RoleChange',
              'Thay đổi vai trò thành $newRole');
        } else if (currentRole == 'Admin' || currentRole == 'Super-Class') {
          await addActionLog(user.uid as String, 'RoleChange',
              'Thay đổi vai trò thành $newRole');
          await _deleteActionLogs(user.uid as String);
        }
      } else if (currentRole == 'Admin' || currentRole == 'Super-Class') {
        await addActionLog(
            user.uid as String, 'Update', 'Cập nhật người dùng: ${user.gmail}');
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      final currentUserRole = currentUserDoc.data()?['role'] as String?;
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data();
      final role = userData?['role'] as String?;

      if (currentUserRole == 'Super-Class' && role == 'Admin') {
        throw Exception('Super-Class không thể xóa người dùng Admin');
      }

      await _firestore.collection('users').doc(uid).delete();
      if (currentUserRole == 'Admin' || currentUserRole == 'Super-Class') {
        await addActionLog(uid, 'Remove',
            'Xóa người dùng: ${userData?['gmail'] ?? 'Không có email'}');
      }
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  Future<void> addActionLog(
      String userId, String actionType, String details) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('action_logs')
        .add({
      'actionType': actionType,
      'timestamp': FieldValue.serverTimestamp(),
      'details': details,
    });
  }

  Future<void> addSearchLog(String userId, String keyword) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('search_logs')
        .add({
      'keyword': keyword,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteActionLog(String userId, String logId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('action_logs')
        .doc(logId)
        .delete();
  }

  Future<void> _deleteActionLogs(String userId) async {
    final logs = await _firestore
        .collection('users')
        .doc(userId)
        .collection('action_logs')
        .get();
    for (var log in logs.docs) {
      await log.reference.delete();
    }
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      final storageRef = _storage.ref().child(
          'avatars/${DateTime.now().millisecondsSinceEpoch}_${image.name}');
      final uploadTask = await storageRef.putFile(File(image.path));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      rethrow;
    }
  }

  Future<void> removePasswordField() async {
    final users = await _firestore.collection('users').get();
    for (var user in users.docs) {
      await user.reference.update({
        'password': FieldValue.delete(),
      });
    }
  }

  Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data()?['role'] as String?;
    }
    return null;
  }
}
