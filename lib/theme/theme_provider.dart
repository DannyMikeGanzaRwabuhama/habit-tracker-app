import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initial: Light Mode
  ThemeData _themeData = lightMode;

  // Get Current Theme
  ThemeData get themeData => _themeData;

  // Set Theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Is Dark Mode
  bool get isDarkMode => _themeData == darkMode;

  // Toggle Theme
  void toggleTheme () {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
