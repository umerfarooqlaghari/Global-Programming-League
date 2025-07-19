import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpVerifyService {
  Future<String> verifyOtp(String email, String otp, String username, String password, String githubLink, String role) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'username': username,
          'password': password,
          'githubLink': githubLink,
          'role': role,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return 'User registered successfully';
      } else {
        return data['error'] ?? 'Failed to register user';
      }
    } catch (error) {
      return 'An error occurred: $error';
    }
  }
}
