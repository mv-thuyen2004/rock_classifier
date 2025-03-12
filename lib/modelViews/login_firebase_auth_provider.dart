import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginFirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool?> signInFirebase(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint("ERROR : ${e.toString()}");
      return false;
    }
  }

  Future<bool?> createAccount(
      String email, String password, String password_2) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      debugPrint("ERROR : ${e.toString()}");
      return false;
    }
  }

  String? ischeckPassword(String password, String password_2) {
    return password == password_2 ? null : "MẬT KHẨU KHÔNG GIỐNG NHAU";
  }
}
