import 'package:flutter/material.dart';
import 'package:readthevoice/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(int theme) {
    if (theme == 0) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
