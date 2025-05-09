import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel?> registerWithEmail(String email, String password) async {
    try {
      // Đăng ký người dùng với Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Mã hóa mật khẩu trước khi lưu
        String hashedPassword = hashPassword(password);

        // Tạo đối tượng UserModel
        UserModel userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          password: hashedPassword,
          role: 'user', // Lưu mật khẩu đã mã hóa
          createdAt: DateTime.now(),
        );

        // Lưu thông tin người dùng vào Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        return userModel;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    } on FirebaseException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
