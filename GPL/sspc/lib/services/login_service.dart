import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http:// 172.16.174.244:5500/api';

  Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('http://localhost:5500/api/login'); // Backend login endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Login successful: ${response.body}');
        return response;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Error: ${response.body}');
        return response;
      }
    } catch (e) {
      print("Error in login: $e");
      rethrow;
    }
  }
}
