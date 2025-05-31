import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p3l_reusemart/constants/api.dart';

import '../models/user_model.dart';
import '../utils/shared_prefs.dart';
import 'notification_service.dart';

class AuthService {
  static Future<LoginResponse?> login(String email, String password) async {
    try {
      // Get FCM token for push notifications
      String? fcmToken = await NotificationService.getFcmToken();
      print('Using FCM token for login: $fcmToken');

      final response = await http.post(
        Uri.parse(Api.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // Save to shared preferences
        await SharedPrefsUtil.setUser(loginResponse.user);
        await SharedPrefsUtil.setToken(loginResponse.token);
        await SharedPrefsUtil.setRole(loginResponse.role);
        await SharedPrefsUtil.setLoggedIn(true);

        return loginResponse;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      print(e.toString());
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      // Get the auth token from shared preferences
      final token = SharedPrefsUtil.getToken();

      if (token != null && token.isNotEmpty) {
        // Make API call to the new logout-mobile endpoint
        final response = await http.post(
          Uri.parse(Api.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('Logout response status: ${response.statusCode}');
        print('Logout response body: ${response.body}');

        if (response.statusCode == 200) {
          print('Successfully logged out on server');
        } else {
          print('Warning: Server logout failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      // Delete FCM token locally as a backup
      try {
        await NotificationService.deleteToken();
      } catch (e) {
        print('Error deleting FCM token: $e');
      }

      // Always clear local storage
      await SharedPrefsUtil.clearAll();
    }
  }
}
