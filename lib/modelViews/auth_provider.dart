import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/Models/user_models.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModels? _currentUser;
  UserModels? get currentUser => _currentUser;

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          _currentUser =
              UserModels.fromMap(doc.data() as Map<String, dynamic>, user.uid);
          notifyListeners();
        } else {
          return "Không tìm thấy user trong Firestore.";
        }
      }
      return null;
    } on FirebaseException catch (e) {
      return "ERROR + ${e.message}";
    }
  }

  Future<String?> signUp(
      String email, String password, String password_2) async {
    if (password != password_2) {
      return "Mật khẩu không khớp ! ";
    }
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        UserModels newUser = UserModels(
          uid: user.uid,
          fullName: null,
          address: null,
          gmail: user.email,
          avatar: null,
          role: "user",
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        _currentUser = newUser;
        notifyListeners();
      }

      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Email Không hợp lệ';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email đã được sử dụng';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu (ít nhất phải 6 kí tự)';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Chức năng đăng kí đang bị tắt';
          break;
        case 'network-request-failed':
          errorMessage = 'Không có kết nối mạng';
          break;
        default:
          errorMessage = 'Đã xảy ra lỗi : ${e.message}';
      }
      return errorMessage;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
