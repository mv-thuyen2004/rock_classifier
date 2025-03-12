import 'package:flutter/material.dart';
import 'package:rock_classifier/core/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isPrimary = true;
  bool get isPrimary => _isPrimary;

  // ThemeData get themeData => _isPrimary ? primaryTheme : secondaryTheme;
  ThemeData get themeData => primaryTheme;
  void toggleTheme() {
    _isPrimary = !_isPrimary;
    notifyListeners();
  }
}
