import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rock_classifier/Models/rock_models.dart';

class FirebaseRockService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = '_rocks';

  //  Lấy toàn bộ đá từ danh sách đá
  Future<List<RockModels>> fetchAllRocks() async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map(
      (doc) {
        return RockModels.fromJson({
          'uid': doc.id,
          ...doc.data(),
        });
      },
    ).toList();
  }

  // Thêm đá mới vào
  Future<void> addRock(RockModels rock) async {
    final docRef = _db.collection(collectionName).doc(rock.uid);
    await docRef.set(rock.toJson());
  }

  // Xóa đá mới theo uid
  Future<void> deleteRockByUid(String uid) async {
    await _db.collection(collectionName).doc(uid).delete();
  }

  // tìm kiếm đá
  Future<List<RockModels>> searchRocks(String keyword) async {
    final snapshot = await _db
        .collection(collectionName)
        .where(
          'tenDa',
          isGreaterThanOrEqualTo: keyword,
        )
        .where('tenDa', isLessThanOrEqualTo: '$keyword\uf8ff')
        .get();
    return snapshot.docs.map((doc) {
      return RockModels.fromJson({
        'uid': doc.id,
        ...doc.data(),
      });
    }).toList();
  }

  // Cập nhật thông tin đá
  Future<void> updateRock(RockModels rock) async {
    final docRef = _db.collection(collectionName).doc(rock.uid);
    await docRef.update(rock.toJson());
  }
}
