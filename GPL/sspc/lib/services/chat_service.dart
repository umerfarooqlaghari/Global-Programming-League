import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sspc/config/app_config.dart';

class ChatService {
  final String baseUrl = AppConfig.apiBaseUrl;

  // Get conversation between user and admin
  Future<List<Map<String, dynamic>>> getConversation(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversation/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load conversation');
      }
    } catch (e) {
      print('Error fetching conversation: $e');
      return [];
    }
  }

  // Get all conversations for admin
  Future<List<Map<String, dynamic>>> getAllConversations() async {
    try {
      print('Fetching conversations from: $baseUrl/conversations');

      final response = await http.get(
        Uri.parse('$baseUrl/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Process each conversation to ensure we have proper user info
        List<Map<String, dynamic>> processedConversations = [];
        for (var conversation in data) {
          Map<String, dynamic> processedConv = Map<String, dynamic>.from(conversation);

          // Try to get user info if username is missing or "Unknown User"
          String userId = processedConv['userId'] ?? processedConv['_id'] ?? '';
          String currentUsername = processedConv['username'] ?? processedConv['userName'] ?? '';

          if (userId.isNotEmpty && (currentUsername.isEmpty || currentUsername == 'Unknown User')) {
            try {
              final userInfo = await getUserInfo(userId);
              if (userInfo != null) {
                processedConv['username'] = userInfo['username'] ?? userInfo['userName'] ?? currentUsername;
                processedConv['email'] = userInfo['email'] ?? processedConv['email'] ?? '';
              }
            } catch (e) {
              print('Error fetching user info for $userId: $e');
            }
          }

          processedConversations.add(processedConv);
        }

        return processedConversations;
      } else {
        throw Exception('Failed to load conversations. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      // Return empty list instead of throwing to prevent app crash
      return [];
    }
  }

  // Send a message via HTTP (backup to socket)
  Future<bool> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required bool isAdmin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': senderId,
          'receiverId': receiverId,
          'message': message,
          'isAdmin': isAdmin,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // Get user info
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return null;
    }
  }
}
