import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:rock_classifier/FirebaseService/firebase_rock_service.dart';
import 'package:rock_classifier/Models/rock_models.dart';

class RockViewModel with ChangeNotifier {
  final FirebaseRockService _service = FirebaseRockService();

  List<RockModels> _rocks = [];
  List<RockModels> get rocks => _rocks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  // Hiển thị đá
  Future<void> fetchRocks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rocks = await _service.fetchAllRocks();
    } catch (e) {
      _error = 'Lỗi $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  // Thêm đá không ảnh
  Future<void> addRock(RockModels rock) async {
    try {
      await _service.addRock(rock);
      await fetchRocks();
    } catch (e) {
      _error = 'Lỗi của thêm đá $e';
      notifyListeners();
    }
  }

  // Xóa đá
  Future<void> deleteRock(String uid) async {
    try {
      await _service.deleteRockByUid(uid);
      _rocks.removeWhere(
        (element) => element.uid == uid,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi xóa đá : $e';
      notifyListeners();
    }
  }

  //Tìm kiếm đá theo tên
  Future<void> searchRock(String keyword) async {
    _isLoading = true;
    notifyListeners();
    try {
      _rocks = await _service.searchRocks(keyword);
    } catch (e) {
      _error = 'Lỗi tìm kiếm đá $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Hàm chọn ảnh từ thư viện hoặc camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  //Up load hình ảnh lên firestrore và trả về url
  Future<String?> uploadImageToFirebase(String folderName) async {
    if (_selectedImage == null) return null;
    try {
      final fileName = basename(_selectedImage!.path);
      final ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');
      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      _error = 'Lỗi tải ảnh (Rock_view_model): $e';
      notifyListeners();
      return null;
    }
  }

  // Hàm add rock có cả image
  Future<void> addRockWithImage(RockModels rock) async {
    _isLoading = true;
    notifyListeners();
    try {
      final imageUrl = await uploadImageToFirebase('rocks');
      if (imageUrl != null) {
        rock = rock.copyWith(hinhAnh: [imageUrl]);
      }
      await _service.addRock(rock);
      await fetchRocks();
    } catch (e) {
      _error = 'Lỗi thêm đá có ảnh $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Cập nhật thông tin đá không có ảnh
  Future<void> updateRockWithoutImage(RockModels rock) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.updateRock(rock); // Gọi phương thức updateRock trong Firebase service
      await fetchRocks(); // Lấy lại danh sách đá sau khi cập nhật
    } catch (e) {
      _error = 'Lỗi cập nhật đá không có ảnh $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật thông tin đá có ảnh
  Future<void> updateRockWithImage(RockModels rock) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Tải ảnh mới lên Firebase và lấy URL ảnh
      final imageUrl = await uploadImageToFirebase('rocks');
      if (imageUrl != null) {
        // Cập nhật lại đá với URL ảnh mới
        rock = rock.copyWith(hinhAnh: [imageUrl]);
      }

      // Cập nhật thông tin đá lên Firebase
      await _service.updateRock(rock);
      await fetchRocks(); // Lấy lại danh sách đá sau khi cập nhật
    } catch (e) {
      _error = 'Lỗi cập nhật đá có ảnh $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortByTenDa() {
    _rocks.sort((a, b) => (a.tenDa ?? '').compareTo(b.tenDa ?? ''));
    notifyListeners();
  }

  void sortByLoaiDa() {
    _rocks.sort((a, b) => (a.loaiDa ?? '').compareTo(b.loaiDa ?? ''));
    notifyListeners();
  }

  void sortByNhomDa() {
    _rocks.sort((a, b) => (a.nhomDa ?? '').compareTo(b.nhomDa ?? ''));
    notifyListeners();
  }
}
