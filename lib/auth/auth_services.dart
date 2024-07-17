import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://api-dev.allia.health/api/client/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Failed to login: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Failed to login');
    }
  }
}
