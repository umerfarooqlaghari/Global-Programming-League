import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final String baseUrl = 'http://localhost:5500/api';
  // final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Retrieve token from secure storage
  //Future<String?> getToken() async {
  // return await _secureStorage.read(key: 'jwt_token');
  //}

  /// Fetch user by username

  Future<Map<String, dynamic>?> getUser(String username) async {
    try {
      final uri = Uri.parse('http://localhost:5500/users/user/$username');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }

  Future<bool> updateUser(String aboutMe) async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      print('Updating user with ID: $userId');
      print('About Me content: $aboutMe');

      final response = await http.post(
        Uri.parse('http://localhost:5500/api/users/updateuser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userId ?? '', // Send user ID in Authorization header
        },
        body: jsonEncode({
          'aboutMe': aboutMe,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed response data: $data');

        if (data['success'] == true) {
          print('User update successful');
          return true; // Successfully updated
        } else {
          print('Update failed - success flag is false');
          return false;
        }
      } else {
        print('HTTP error with status code: ${response.statusCode}');
        print('Error response: ${response.body}');

        // Try to parse error message
        try {
          final errorData = jsonDecode(response.body);
          print('Error message: ${errorData['error']}');
        } catch (e) {
          print('Could not parse error response');
        }
        return false;
      }
    } catch (e) {
      print('Exception when updating user: $e');
      return false; // Indicate failure to update
    }
  }

  Future<bool> uploadProfilePicture(File imageFile) async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      print('Uploading profile picture for user ID: $userId');
      print('Image file path: ${imageFile.path}');

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://localhost:5500/api/users/update-profile'),
      );

      // Add headers
      request.headers['Authorization'] = userId ?? '';

      // Add user ID to the request
      request.fields['userId'] = userId ?? '';

      // Handle file upload differently for web and mobile
      if (kIsWeb) {
        // For web, read file as bytes
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'profilePicture',
            bytes,
            filename: 'profile_picture.jpg',
          ),
        );
      } else {
        // For mobile/desktop, use file path
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            imageFile.path,
          ),
        );
      }

      print('Sending multipart request...');

      // Send the request
      var response = await request.send();

      print('Upload response status: ${response.statusCode}');

      // Read response body for debugging
      String responseBody = await response.stream.bytesToString();
      print('Upload response body: $responseBody');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(responseBody);
          if (data['success'] == true) {
            print('Profile picture upload successful');
            return true;
          } else {
            print('Upload failed - success flag is false');
            return false;
          }
        } catch (e) {
          print('Error parsing upload response: $e');
          return false;
        }
      } else {
        print('HTTP error with status code: ${response.statusCode}');
        print('Error response: $responseBody');
        return false;
      }
    } catch (e) {
      print('Exception when uploading profile picture: $e');
      return false;
    }
  }

  Future<bool> removeProfilePicture() async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      print('Removing profile picture for user ID: $userId');

      final response = await http.put(
        Uri.parse('http://localhost:5500/api/users/remove-profile-picture'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userId ?? '',
        },
        body: jsonEncode({
          'userId': userId,
        }),
      );

      print('Remove profile picture response status: ${response.statusCode}');
      print('Remove profile picture response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            print('Profile picture removal successful');
            return true;
          } else {
            print('Removal failed - success flag is false');
            return false;
          }
        } catch (e) {
          print('Error parsing removal response: $e');
          return false;
        }
      } else {
        print('HTTP error with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception when removing profile picture: $e');
      return false;
    }
  }
}
