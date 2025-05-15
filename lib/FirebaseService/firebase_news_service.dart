import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/Models/news_models.dart';

class FirebaseNewsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = '_news';

  // Lấy tất cả dữ liệu
  Future<List<NewsModels>> fetchNews() async {
    final snapshot = await _db.collection(collectionName).get();

    return snapshot.docs
        .map(
          (doc) => NewsModels.fromJson(doc.data(), doc.id),
        )
        .toList();
  }

  //CẬP NHẬT
  Future<void> updateNews(NewsModels news) async {
    try {
      final docRef = _db.collection(collectionName).doc(news.uid);
      await docRef.update(
        news.toJson(),
      );
    } catch (e) {
      debugPrint('LỖI Ở CẬP NHẬT FIREBASE : $e');
    }
  }
  // TÌM KIẾM

  Future<List<NewsModels>> searchNews(String keyword) async {
    final snapshot = await _db
        .collection(collectionName)
        .where(
          'tenBaiViet',
          isGreaterThanOrEqualTo: keyword,
        )
        .where(
          'tenBaiViet',
          isLessThanOrEqualTo: '$keyword\uf8ff',
        )
        .get();
    return snapshot.docs
        .map(
          (doc) => NewsModels.fromJson(doc.data(), doc.id),
        )
        .toList();
  }

  // XÓA
  Future<void> deleteNewsByUid(String uid) async {
    await _db.collection(collectionName).doc(uid).delete();
  }

  // THÊM
  Future<void> addNews(NewsModels news) async {
    final docRef = _db.collection(collectionName).doc();
    await docRef.set(news.toJson());
  }
}
