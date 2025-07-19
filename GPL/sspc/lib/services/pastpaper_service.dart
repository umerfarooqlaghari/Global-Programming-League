import 'package:http/http.dart' as http;
import 'dart:convert';

class PastpaperService {
  static const String baseUrl = "http://localhost:5500/api/api/pastpaper";

  /// Upload a past paper (POST /pastpaper)
  static Future<bool> uploadPastPaper(
      String kind, String date, String name, String link) async {
    final url = Uri.parse("http://localhost:5500/api/pastpaper/pastpaper");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kind': kind,
          'date': date,
          'name': name,
          'link': link,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed response: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading past paper: $e');
      return false;
    }
  }

  /// Get all past papers (GET /getpastpaper)
  static Future<List<Map<String, dynamic>>> getPastPapers() async {
    final url = Uri.parse("http://localhost:5500/api/pastpaper/getpastpaper");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 404) {
        print("No past papers found.");
        return [];
      } else {
        print("Failed to load past papers: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching past papers: $e");
      return [];
    }
  }

  /// Delete a past paper (DELETE /pastpapers/:id)
  static Future<bool> deletePastPaper(String id) async {
    final url = Uri.parse("http://localhost:5500/apipastpaper/pastpapers/$id");

    try {
      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        print("Past paper not found");
        return false;
      } else {
        print("Error deleting past paper: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception while deleting past paper: $e");
      return false;
    }
  }
}
