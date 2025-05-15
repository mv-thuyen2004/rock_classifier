import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rock_classifier/FirebaseService/firebase_news_service.dart';
import 'package:rock_classifier/Models/news_models.dart';

class NewsViewModel with ChangeNotifier {
  final FirebaseNewsService _service = FirebaseNewsService();

  List<NewsModels> _news = [];
  List<NewsModels> get news => _news;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  // HIỂN THỊ
  Future<void> fetchNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _news = await _service.fetchNews();
    } catch (e) {
      _error = 'Lỗi $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  // XÓA
  Future<void> deleteNews(String uid) async {
    try {
      await _service.deleteNewsByUid(uid);
      _news.removeWhere(
        (element) => element.uid == uid,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Lỗi xóa HÀM XÓA : $e';
      notifyListeners();
    }
  }

  // TÌM KIẾM
  Future<void> searchNews(String keyword) async {
    _isLoading = true;
    notifyListeners();
    try {
      _news = await _service.searchNews(keyword);
    } catch (e) {
      _error = 'LỖI TÌM KIẾM FILE NEWS VIEW MODEL : $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // THÊM KHÔNG ẢNH
  Future<void> addNews(NewsModels news) async {
    try {
      await _service.addNews(news);
      await fetchNews();
    } catch (e) {
      _error = 'LỖI THÊM ĐÁ KHÔNG KÈM HÌNH ẢNH $e';
      notifyListeners();
    }
  }

  // SẮP XẾP SỚM NHẤT ĐẾN MUỘN NHẤT
  void sortByCreatAtUP() {
    _news.sort((a, b) => (a.createAt).compareTo(b.createAt));
    notifyListeners();
  }

  void sortByCreatAtDPWN() {
    _news.sort((a, b) => (b.createAt).compareTo(a.createAt));
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

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  //Up load hình ảnh lên firestrore và trả về url
  Future<String?> uploadImageToFirebase(String uid) async {
    if (_selectedImage == null) return null;
    try {
      final ref = FirebaseStorage.instance.ref().child('baiBao/$uid/hinhAnh.jpg');
      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      _error = 'Lỗi tải ẢNH LÊN SEVER:  $e';
      notifyListeners();
      return null;
    }
  }

  // CẬP NHẬT
  Future<void> updateNews(NewsModels news) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.updateNews(news); // Gọi phương thức updateRock trong Firebase service
      // await fetchNews(); // Lấy lại danh sách đá sau khi cập nhật
      await fetchNews();
    } catch (e) {
      _error = 'LỖI CẬP NHẬT BÀI VIẾT : $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //HÀM CẬP NHẬT CÓ ẢNH

  Future<void> updatenNewsWithImage(NewsModels news) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final imageUrl = await uploadImageToFirebase(news.uid);
      if (imageUrl != null) {
        // Cập nhật lại đá với URL ảnh mới
        news = news.copyWith(fileDinhKem: imageUrl);
      }

      await _service.updateNews(news);
      await fetchNews();
    } catch (e) {
      _error = 'Lỗi CẬP NHẬT CÓ ẢNH $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // THÊM CÓ ẢNH
  Future<void> addNewsWithImage(NewsModels news) async {
    _isLoading = true;
    notifyListeners();
    try {
      final imageUrl = await uploadImageToFirebase(news.uid);
      if (imageUrl != null) {
        news = news.copyWith(fileDinhKem: imageUrl);
      }
      await _service.addNews(news);
      await fetchNews();
    } catch (e) {
      _error = 'Lỗi THÊM BÀO BÁO CÓ ẢNH $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
