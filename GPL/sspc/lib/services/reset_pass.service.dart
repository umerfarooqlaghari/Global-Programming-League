import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String baseUrl = 'http://localhost:5500/api';

  // Reset Password with OTP
  Future<String> resetPassword(String email, String otp, String newPassword, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('http:// 172.16.174.244:5500/api/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return 'Password reset successfully!';
      } else {
        final errorResponse = json.decode(response.body);
        return errorResponse['error'];
      }
    } catch (e) {
      return 'unable to reset password: $e';
    }
  }
}
