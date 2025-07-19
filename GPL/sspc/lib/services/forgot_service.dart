import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String baseUrl = 'http://localhost:5500/api';

  // Send OTP for Forgot Password
  Future<String> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return 'OTP sent to your email!';
      } else {
        final errorResponse = json.decode(response.body);
        return errorResponse['error'];
      }
    } catch (e) {
      return 'Failed to send OTP: $e';
    }
  }
}
