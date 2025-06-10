// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = 'http://deevcreed.runasp.net';

  Future<http.Response> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 15));

      return response;
    } catch (e) {
      log('SignUp Error: $e');
      rethrow;
    }
  }

  Future<http.Response> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response;
  }
}