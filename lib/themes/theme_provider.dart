import 'package:chatii_app/themes/dark_mode.dart';
import 'package:chatii_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData; 

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();  
  }
}