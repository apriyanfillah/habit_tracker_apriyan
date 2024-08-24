import 'package:flutter/material.dart';
import 'package:habit_tracker_apriyan/theme/light_mode.dart';
import 'package:habit_tracker_apriyan/theme/dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, Light Mode
  ThemeData _themeData = lightMode;

  // Get Current Theme
  ThemeData get themeData => _themeData;

  // Is Current Theme Dark Mode
  bool get isDarkMode => _themeData == darkMode;

  // Set Theme
  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle Theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      setTheme(darkMode);
    } else {
      setTheme(lightMode);
    }
  }
}
