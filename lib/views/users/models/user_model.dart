import 'package:cloud_firestore/cloud_firestore.dart'; // Thêm import này

class UserModel {
  final String uid;
  final String email;
  final String password;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
  });

  // Phương thức từ Map để khởi tạo UserModel từ dữ liệu trong Firestore
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      password: data['password'],
      role: data['role'],
      createdAt: (data['createdAt'] as Timestamp)
          .toDate(), // Sử dụng Timestamp từ cloud_firestore
    );
  }

  // Phương thức chuyển đổi UserModel thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': Timestamp.fromDate(
          createdAt), // Sử dụng Timestamp để chuyển đổi DateTime thành Firestore Timestamp
    };
  }
}
