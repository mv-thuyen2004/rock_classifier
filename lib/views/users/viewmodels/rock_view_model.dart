import 'package:flutter/material.dart';
import 'package:nckh/models/rock_model.dart';
import 'package:nckh/untils/rock_repository.dart';

class RockViewModel extends ChangeNotifier {
  final RockRepository _repository = RockRepository();
  List<RockModel> _rocks = [];
  List<RockModel> get rocks => _rocks;

  List<String> _categories = ['Tất cả'];
  List<String> get categories => _categories;

  String _selectedCategory = 'Tất cả';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadRocks() async {
    _rocks = await _repository.fetchRocks();
    _categories = await _repository.fetchCategories();
    notifyListeners();
  }

  List<RockModel> get filteredRocks {
    if (_selectedCategory == 'Tất cả') return _rocks;
    return _rocks.where((r) => r.nhanhDa == _selectedCategory).toList();
  }
}
