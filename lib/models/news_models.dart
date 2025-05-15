import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModels {
  String uid;
  String tenBaiViet;
  String? noiDungBaiViet;
  String? fileDinhKem;
  String? duongDan;
  String? chuDe;
  DateTime createAt;

  NewsModels({
    required this.uid,
    required this.tenBaiViet,
    this.noiDungBaiViet,
    this.fileDinhKem,
    this.duongDan,
    this.chuDe,
    required this.createAt,
  });

  factory NewsModels.fromJson(Map<String, dynamic> json, String documentId) {
    return NewsModels(
      uid: documentId,
      tenBaiViet: json['tenBaiViet'],
      noiDungBaiViet: json['noiDungBaiViet'],
      fileDinhKem: json['fileDinhKem'],
      duongDan: json['duongDan'],
      chuDe: json['chuDe'],
      createAt: (json['createAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'tenBaiViet': tenBaiViet,
      'noiDungBaiViet': noiDungBaiViet,
      'fileDinhKem': fileDinhKem,
      'duongDan': duongDan,
      'chuDe': chuDe,
      'createAt': Timestamp.fromDate(createAt),
    };
  }

  NewsModels copyWith({
    String? uid,
    String? tenBaiViet,
    String? noiDungBaiViet,
    String? fileDinhKem,
    String? duongDan,
    String? chuDe,
    DateTime? createAt,
  }) {
    return NewsModels(
      uid: uid ?? this.uid,
      tenBaiViet: tenBaiViet ?? this.tenBaiViet,
      noiDungBaiViet: noiDungBaiViet ?? this.noiDungBaiViet,
      fileDinhKem: fileDinhKem ?? this.fileDinhKem,
      duongDan: duongDan ?? this.duongDan,
      chuDe: chuDe ?? this.chuDe,
      createAt: createAt ?? this.createAt,
    );
  }
}
