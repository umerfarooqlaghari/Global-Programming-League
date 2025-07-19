import 'package:flutter/material.dart';
import 'package:sspc/reset.dart';
import 'package:sspc/services/otp_verifyservice.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  OtpVerificationScreen({required this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  String _message = '';
  bool _isOtpVerified = false;

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      setState(() {
        _message = 'Please enter the OTP';
      });
      return;
    }

    final result = await OtpVerificationService().verifyOtp(widget.email, otp);
    setState(() {
      if (result == 'OTP verified successfully') {
        _isOtpVerified = true;
        _message = result;
      } else {
        _message = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP Code',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'A 6-digit code was sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Verify OTP', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 16),
            Text(_message, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
            if (_isOtpVerified)
              Column(
                children: [
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(email: widget.email),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Reset Password', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Resend OTP action
              },
              child: Text('Resend OTP', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
