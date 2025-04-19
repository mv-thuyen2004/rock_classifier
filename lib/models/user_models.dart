class UserModels {
  final String uid;
  final String? fullName;
  final String? address;
  final String? gmail;
  final String? avatar;
  final String? role;

  UserModels({
    required this.uid,
    required this.fullName,
    required this.address,
    required this.gmail,
    required this.avatar,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'address': address,
      'gmail': gmail,
      'avatar': avatar,
      'role': role,
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map, String uid) {
    return UserModels(
        uid: map['uid'] ?? '',
        fullName: map['fullName'],
        address: map['address'],
        gmail: map['gmail'],
        avatar: map['avatar'],
        role: map['role']);
  }
}
