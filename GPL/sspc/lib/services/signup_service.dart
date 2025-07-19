import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  final String baseUrl = 'http://192.168.1.103:5500/api';

  /// Sign up function
  Future<int> signupInDatabase(
    String username,
    String email,
    String password,
    String confirmPassword,
    String githubLink,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPass': confirmPassword,
          'githubLink': githubLink,
        }),
      );

      // Log response for debugging
      print('Signup Response: ${response.statusCode}');
      print('Signup Body: ${response.body}');

      return response.statusCode;
    } catch (e) {
      print("Error in signup: $e");
      rethrow; // Propagate error
    }
  }

}
