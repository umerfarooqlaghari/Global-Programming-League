import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sspc/dashboard.dart';
import 'package:sspc/forgotpassword.dart';
import 'package:sspc/services/my_shared_prefences.dart';
import 'package:sspc/signup_screen.dart';
import 'package:sspc/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    LoginService authService = LoginService();
    final response = await authService.login(username, password);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final email = responseData['email'];
      final githubLink = responseData['githubLink'] ?? ''; // Null check

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );

      print(responseData);
      await saveUserData(email, username, responseData['userId'], githubLink);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            userName: username,
            userEmail: email,
            userProfilePicture: "https://example.com/profile.jpg",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 400 : double.infinity, // Constrain width on large screens
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 32 : 24,
              vertical: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Logo with proper size and fallback image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Rounded edges
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, size: 60, color: Colors.blue);
                    },
                  ),
                ),
                
                const SizedBox(height: 30),
                
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 48),
                
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                ),

                Row(
                  children: [
                    Checkbox(value: false, onChanged: (bool? value) {}),
                    const Text('Remember me')
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Sign In Button
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Log in'),
                ),
                
                const SizedBox(height: 24),

                // Forgot Password
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFF0099FF), decoration: TextDecoration.underline),
                  ),
                ),

                const SizedBox(height: 16),

                // Sign Up Navigation
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'Don’t have an account yet? Create account',
                    style: TextStyle(color: Color(0xFF0099FF), decoration: TextDecoration.underline),
                  ),
                ),

                const SizedBox(height: 16),
                const Text('Terms and conditions'),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}
