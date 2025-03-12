import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _user = _auth.currentUser;
  }

  User? get user => _user;

  Future<String?> signIn(String email, String pass) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      _user = userCredential.user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUp(String email, String pass, String pass_2) async {
    if (pass != pass_2) {
      return "MẬT KHẨU KHÔNG KHỚP !";
    }
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      _user = userCredential.user;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint("ERROR : ${e.toString()}");
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
