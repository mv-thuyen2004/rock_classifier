// lib/models/forgot_password_model.dart
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordModel {
  Future<void> sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }
}
