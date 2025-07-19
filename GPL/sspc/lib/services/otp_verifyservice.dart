import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpVerificationService {
  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return 'OTP verified successfully';
      } else {
        return data['error'] ?? 'Failed to verify OTP';
      }
    } catch (error) {
      return 'An error occurred: $error';
    }
  }
}
