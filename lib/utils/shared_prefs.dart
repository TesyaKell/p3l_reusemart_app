import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class SharedPrefsUtil {
  static late SharedPreferences _prefs;

  // Keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Login status
  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  // User data
  static User? getUser() {
    final userString = _prefs.getString(_userKey);
    if (userString == null) return null;

    final userMap = jsonDecode(userString) as Map<String, dynamic>;
    return User(
      id: userMap['id'] ?? '',
      name: userMap['name'] ?? '',
      email: userMap['email'] ?? '',
      phone: userMap['phone'] ?? '',
      role: userMap['role'] ?? '',
      points: userMap['points'] ?? 0,
      balance: (userMap['balance'] ?? 0).toDouble(),
      isTopSeller: userMap['isTopSeller'] ?? false,
      originalData: userMap['originalData'] ?? {},
    );
  }

  static Future<void> setUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Token
  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  // Role
  static String? getRole() {
    return _prefs.getString(_roleKey);
  }

  static Future<void> setRole(String role) async {
    await _prefs.setString(_roleKey, role);
  }

  // Clear all data on logout
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
