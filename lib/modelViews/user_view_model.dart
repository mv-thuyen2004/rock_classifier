import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/Models/user_models.dart';

class UserViewModel with ChangeNotifier {
  final FirebaseService _firebaseService;
  UserModels? _currentUser;
  UserModels? get currentUser => _currentUser;

  UserViewModel() : _firebaseService = FirebaseService();

  Stream<UserModels?> getUserById(String uid) {
    return _firebaseService.getUserById(uid);
  }

  Stream<List<UserModels>> getUsers() {
    return _firebaseService.getUsers();
  }

  void fetchUser(String uid) {
    _firebaseService.getUserById(uid).listen(
      (event) {
        _currentUser = event;
        notifyListeners();
      },
    );
  }

  Future<Map<String, dynamic>> getUsersPaginated({
    int pageSize = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    return await _firebaseService.getUsersPaginated(
      limit: pageSize,
      lastDocument: lastDocument,
    );
  }

  Stream<List<Map<String, dynamic>>> getActionLogs(String userId) {
    return _firebaseService.getActionLogs(userId);
  }

  Stream<List<Map<String, dynamic>>> getSearchLogs(String userId) {
    return _firebaseService.getSearchLogs(userId);
  }

  Future<void> addUser(UserModels user) async {
    await _firebaseService.addUser(user);
    notifyListeners();
  }

  Future<void> updateUser(UserModels user) async {
    await _firebaseService.updateUser(user);
    notifyListeners();
  }

  Future<void> deleteUser(UserModels user) async {
    await _firebaseService.deleteUser(user.uid!);
    notifyListeners();
  }

  Future<void> addSearchLog(String userId, String keyword) async {
    await _firebaseService.addSearchLog(userId, keyword);
  }

  Future<void> deleteActionLog(String userId, String logId) async {
    await _firebaseService.deleteActionLog(userId, logId);
    notifyListeners();
  }

  Future<String?> uploadImage(XFile image) async {
    return await _firebaseService.uploadImage(image);
  }

  Future<String?> getCurrentUserRole() async {
    return await _firebaseService.getCurrentUserRole();
  }
}
