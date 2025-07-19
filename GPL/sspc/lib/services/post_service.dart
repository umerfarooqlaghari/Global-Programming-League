import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostService {
  final String baseUrl = 'http://localhost:5500/api';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Retrieve token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  /// Fetch all posts (feed)
  Future<List<dynamic>> getPosts() async {
    final token = await getToken();
    //if (token == null) {
    //  throw Exception('Authorization token not found');
    //}

    try {
      final response = await http.get(
        Uri.parse('http://localhost:5500/api/posts/getFeedPosts'),

        headers: {
          //'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response);
      if (response.statusCode == 200) {
        return List<dynamic>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching posts: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getSearchedPosts(String searchText) async {
    final token = await getToken();
    // if (token == null) {
    //   throw Exception('Authorization token not found');
    // }

    try {
      // Add searchText as a query parameter to the URL
      final response = await http.get(
        Uri.parse('http://localhost:5500/api/posts/getSearchedPosts?searchText=$searchText'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response);
      if (response.statusCode == 200) {
        return List<dynamic>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching posts: $e");
      rethrow;
    }
  }

  /// Create a new post
  Future<List<dynamic>> createPost(dynamic request) async {
    final token = await getToken();
    //if (token == null) {
    //  throw Exception('Authorization token not found');
    //}

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/posts/postcreate'),
        headers: {
          //'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      print("Error creating post: $e");
      rethrow;
    }
  }

  /// Like or unlike a post
  Future<Map<String, dynamic>?> likePost(String postId, String username) async {
    try {
      final response = await http.patch(
        Uri.parse('http://localhost:5500/api/posts/$postId/like'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the updated post
      } else {
        throw Exception('Failed to like/unlike post: ${response.statusCode}');
      }
    } catch (e) {
      print("Error liking/unliking post: $e");
      rethrow; // Re-throw the exception for further handling
    }
  }

  // Add Comment
  Future<List<dynamic>?> addComment(String postId, String comment, String? username) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5500/api/posts/$postId/comments'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'comment': comment, 'username': username}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse and return the updated comments list from the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['comments']; // Assuming the backend returns updated comments here
      } else {
        print("Failed to add comment. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error adding comment: $e");
      rethrow;
    }
  }

  /// Fetch likes for a post
  Future<List<String>> getPostLikes(String postId) async {
    // final token = await getToken();
    //if (token == null) {
    //  throw Exception('Authorization token not found');
    //}

    try {
      final response = await http.get(
        Uri.parse('http://localhost:5500/api/posts/$postId/likes'),
      );

      if (response.statusCode == 200) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch likes: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching likes: $e");
      rethrow;
    }
  }
}
