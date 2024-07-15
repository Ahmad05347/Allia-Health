import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    const loginUrl = 'https://api-dev.allia.health/api/client/auth/login';
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
