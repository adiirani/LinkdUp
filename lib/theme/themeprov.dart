import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dark.dart';
import 'light.dart';

class Themeprov extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  late final Box preferences;

  Themeprov() {
    _init();
  }

  Future<void> _init() async {
    preferences = await Hive.openBox('preferences'); // Open the box properly
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  bool get isDark => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme();
    notifyListeners();
  }

  void toggleTheme() {
    themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }

  void _saveTheme() {
    preferences.put('isDarkMode', isDark);
  }

  void _loadTheme() {
    final isDarkMode = preferences.get('isDarkMode', defaultValue: false);
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners(); // Notify listeners after loading theme
  }
}
