import 'package:cloud_firestore/cloud_firestore.dart';

class UserModels {
  String uid;
  String? fullName;
  String? address;
  String email;
  String? avatar;
  String role;
  DateTime createdAt;

  UserModels({
    required this.uid,
    this.fullName,
    this.address,
    required this.email,
    this.avatar,
    required this.role,
    required this.createdAt,
  });

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      uid: json['uid'],
      fullName: json['fullName'] as String?,
      address: json['address'] as String?,
      email: json['email'],
      avatar: json['avatar'] as String?,
      role: json['role'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Chuyển đổi đối tượng UserModels thành map để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'email': email,
      'avatar': avatar,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt), // lưu dạng ISO string
    };
  }

  /// Tạo một bản sao mới của đối tượng, cho phép cập nhật các thuộc tính
  UserModels copyWith({
    String? uid,
    String? fullName,
    String? address,
    String? email,
    String? avatar,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModels(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
