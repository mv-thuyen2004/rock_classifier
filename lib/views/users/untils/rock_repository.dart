import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nckh/models/rock_model.dart';

class RockRepository {
  final CollectionReference _rockCollection =
      FirebaseFirestore.instance.collection('rock_');

  Future<List<RockModel>> fetchRocks() async {
    final snapshot = await _rockCollection.get();
    return snapshot.docs
        .map((doc) => RockModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final snapshot = await _rockCollection.get();
    final all = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['nhanh_da'] ?? '')
        .toSet()
        .toList();
    all.removeWhere((element) => element.isEmpty);
    all.sort();
    return ['Tất cả', ...all];
  }
}
