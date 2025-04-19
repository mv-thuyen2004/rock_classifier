import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/models/user_models.dart';

class UserProvider with ChangeNotifier {
  UserModels? _user;
  bool _isLoading = true;

  UserModels? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (snapshot.exists) {
        _user = UserModels.fromMap(snapshot.data()!, uid);
      }
    } catch (e) {
      debugPrint('Error fetching user $e');
    } finally {
      _isLoading = true;
      notifyListeners();
    }
  }

  Future<void> updateUserData() async {
    if (_user == null) return;
    try {
      await FirebaseFirestore.instance.collection("users").doc(_user!.uid).set(
            _user!.toMap(),
          );
    } catch (e) {
      debugPrint("Error Update User Data : $e");
    }
  }

  Future<void> updateFullName(String name) async {
    _user = _user?.copyWith(fullName: name);
    notifyListeners();
  }

  Future<void> updateAddress(String address) async {
    _user = _user?.copyWith(address: address);
    notifyListeners();
  }

  Future<void> updateGmail(String gmail) async {
    _user = _user?.copyWith(gmail: gmail);
    notifyListeners();
  }
}

extension on UserModels {
  UserModels copyWith({
    String? fullName,
    String? address,
    String? gmail,
    String? avatar,
    String? role,
  }) {
    return UserModels(
      uid: uid,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      gmail: gmail ?? this.gmail,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
    );
  }
}
