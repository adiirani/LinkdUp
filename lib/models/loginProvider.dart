import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _hasSeenAuthScreen = false;
  bool get hasAuthenticated => _isAuthenticated;

  bool get isAuthenticated => _isAuthenticated;
  bool get hasSeenAuthScreen => _hasSeenAuthScreen;


  // Load authentication status (e.g., after app restart)
  Future<void> loadAuthStatus() async {
    var box = await Hive.openBox('authBox');
    _isAuthenticated = box.get('isAuthenticated', defaultValue: false);
    _hasSeenAuthScreen = box.get('hasSeenAuthScreen', defaultValue: false);
    notifyListeners();
  }

  Future<void> setAuthenticated(bool value) async {
    _isAuthenticated = value;
    var box = await Hive.openBox('authBox');
    await box.put('isAuthenticated', value);
    notifyListeners();
  }

  Future<void> markAuthScreenSeen() async {
    _hasSeenAuthScreen = true;
    var box = await Hive.openBox('authBox');
    await box.put('hasSeenAuthScreen', true);
    notifyListeners();
  }

  // Login method to authenticate a user
  Future<void> login(String email, String password) async {
    var box = await Hive.openBox('authBox');
    var storedPassword = box.get('user_$email');

    if (storedPassword == password) {
      _isAuthenticated = true;
      box.put('isAuthenticated', true);
      notifyListeners();
    } else {
      // Optional: Handle invalid login (e.g., show a message or log error)
    }
  }

  // Create account method
  Future<bool> createAccount(String email, String password) async {
    var box = await Hive.openBox('authBox');

    if (box.containsKey('user_$email')) {
      return false; // Email already exists
    }

    box.put('user_$email', password);
    return true;
  }

  // Logout method
  Future<void> logout() async {
    _isAuthenticated = false;
    var box = await Hive.openBox('authBox');
    box.put('isAuthenticated', false);
    notifyListeners();
  }
}
