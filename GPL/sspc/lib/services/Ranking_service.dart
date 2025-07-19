import 'package:http/http.dart' as http;
import 'dart:convert';

class RankingService {
  final String apiUrl = "http://localhost:5500/api/Rankings/Rankings";

  // Post rankings
  Future<bool> postRankings(
      String competitionName, List<Map<String, dynamic>> rankings) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "competitionName": competitionName,
          "rankings": rankings,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error posting rankings: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRankings(String competitionName) async {
    final String url =
        "http://localhost:5500/api/Rankings/rankings/$competitionName";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);

        // ✅ Extract the actual rankings list
        final List<dynamic> rankingsData = result['rankings'];

        return List<Map<String, dynamic>>.from(rankingsData);
      } else {
        print(
            "Error fetching rankings: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception while fetching rankings: $e");
      return [];
    }
  }

// Get all rankings from all competitions
  Future<List<Map<String, dynamic>>> getAllRankings() async {
    final String url = "http://localhost:5500/api/Rankings/all-rankings";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);
        return List<Map<String, dynamic>>.from(result);
      } else {
        print(
            "Error fetching all rankings: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception while fetching all rankings: $e");
      return [];
    }
  }

  // Delete rankings by competition name
  Future<bool> deleteRankings(String competitionName) async {
    final String url =
        "http://localhost:5500/api/Rankings/rankings/$competitionName";

    try {
      final response = await http.delete(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        print("Rankings deleted successfully for: $competitionName");
        return true;
      } else {
        print(
            "Error deleting rankings: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception while deleting rankings: $e");
      return false;
    }
  }
}
