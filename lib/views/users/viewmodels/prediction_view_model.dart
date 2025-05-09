import 'package:flutter/material.dart';
import 'package:nckh/models/rock_classifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;

class PredictionViewModel extends ChangeNotifier {
  String? rockName;
  String? description;
  String? composition;
  String? mineralRelation;
  String? chemicalComposition;
  String? rockType;
  String? rockGroup;
  String? rockBranch;
  String? texture;
  String? color;
  String? structure;
  String? distribution;
  String? layingForm;
  String? hardness;
  String? density;
  String? features;
  String? id;
  List<String> imageUrls = [];

  String errorMessage = '';

  Future<void> predictRockFromImage(img.Image image) async {
    try {
      final classifier = RockClassifier();
      await classifier.loadModel();

      final result = await classifier.predict(image);
      final predictedIndex = result['predictedIndex'];

      if (predictedIndex == 5) {
        errorMessage = 'Không phải đá';
        notifyListeners();
        return;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('rock_')
          .doc(predictedIndex.toString())
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        // Gán dữ liệu từ Firestore vào các biến
        rockName = data['ten_da'];
        description = data['mo_ta'];
        composition = data['cau_tao'];
        mineralRelation = data['khoangsan_lq'];
        chemicalComposition = data['tp_hoahoc'];
        rockType = data['loai_da'];
        rockGroup = data['nhom_da'];
        rockBranch = data['nhanh_da'];
        texture = data['kien_truc'];
        color = data['mau_sac'];
        structure = data['th_khoangvat'];
        distribution = data['noi_phanbo'];
        layingForm = data['dang_nam'];
        hardness = data['do_cung'];
        density = data['mat_do'];
        features = data['dac_diem'];
        id = data['id'];
        imageUrls = List<String>.from(data['anh_da'] ?? []);

        errorMessage = '';
      } else {
        errorMessage = 'Không tìm thấy dữ liệu đá trong Firebase.';
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Đã có lỗi xảy ra: $e';
      notifyListeners();
    }
  }
}
