import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sspc/login_screen.dart';
import 'package:sspc/services/my_shared_prefences.dart';
import 'package:sspc/services/otp_verifyservice.dart';
import 'package:sspc/services/otp_verifysignup.dart';
import 'package:sspc/services/signup_service.dart';

class OTPDialog extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final String githubLink;
  final String role;
  final VoidCallback onOtpVerified;

  OTPDialog({
    required this.email,
    required this.username,
    required this.password,
    required this.githubLink,
    this.role = 'student',  // Default role as student if not otherwise specified
    required this.onOtpVerified,
  });

  @override
  _OTPDialogState createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  List<TextEditingController> otpControllers = [];
  List<FocusNode> focusNodes = [];
  late Timer _timer;
  int _remainingTime = 60;  // OTP expiry time
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP has expired. Please resend OTP.')),
        );
      }
    });
  }

  Future<void> _verifyOtp() async {
    String otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length == 6) {
      setState(() {
        _isLoading = true;
      });

      OtpVerifyService authService = OtpVerifyService();
      final response = await authService.verifyOtp(
        widget.email.trim().toLowerCase(),
        otp,
        widget.username,
        widget.password,
        widget.githubLink,
        widget.role,
      );

      setState(() {
        _isLoading = false;
      });

      if (response == 'User registered successfully') {
        widget.onOtpVerified();  // Trigger any additional action on successful verification
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the complete OTP.')),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF3F3F3F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              'Enter the OTP sent to your email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  height: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _remainingTime > 0
                  ? 'Resend OTP in $_remainingTime seconds'
                  : 'OTP expired. Please resend OTP.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text('Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1B6590),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
