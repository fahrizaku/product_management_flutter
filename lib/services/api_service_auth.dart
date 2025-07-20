// lib/services/api_service_auth.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_login_response.dart';
import 'token_service.dart';

class ApiServiceAuth {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';
  static String get loginUrl => '$baseUrl/api/auth/login';
  static String get registerUrl => '$baseUrl/api/auth/register';

  // Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Login
  static Future<UserLoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = UserLoginResponse.fromJson(data);

        // Simpan token dan user ke SharedPreferences
        await TokenService.saveToken(loginResponse.token);
        await TokenService.saveUser(loginResponse.user.toJson());

        return loginResponse;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    await TokenService.clearAll();
  }

  // Ambil user yang sedang login
  static Future<User?> getCurrentUser() async {
    final userData = await TokenService.getUser();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  // Buat header dengan token untuk request yang butuh authentication
  static Future<Map<String, String>> getHeaders() async {
    final token = await TokenService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
