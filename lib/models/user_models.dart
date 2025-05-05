import 'package:cloud_firestore/cloud_firestore.dart';

class UserModels {
  final String? uid;
  final String? fullName;
  final String? address;
  final String? gmail;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;

  UserModels({
    this.uid,
    this.fullName,
    this.address,
    this.gmail,
    this.avatar,
    this.role,
    this.createdAt,
  });

  factory UserModels.fromMap(Map<String, dynamic> map, String id) {
    return UserModels(
      uid: id,
      fullName: map['fullName'],
      address: map['address'],
      gmail: map['gmail'],
      avatar: map['avatar'],
      role: map['role'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'gmail': gmail,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  UserModels copyWith({
    String? uid,
    String? fullName,
    String? address,
    String? gmail,
    String? avatar,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModels(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      gmail: gmail ?? this.gmail,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// coppyWith : tạo bản sao mới của object , thay đổi một số thuộc tính
// fromMap : Chuyển dữ liệu (map/json) thành Oject Dart 
// toMap : Chuyển oject Dart thành map (để lưu hoặc gửi đi)