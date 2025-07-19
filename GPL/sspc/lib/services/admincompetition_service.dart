import 'dart:convert';
import 'package:http/http.dart' as http;

class CompetitionsService {
  static const String baseUrl = "http://localhost:5500/api";

  static Future<bool> postCompetition(
      Map<String, dynamic> competitionData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/competitions/competitions"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(competitionData),
      );

      print("Competition post response: ${response.statusCode}");
      print("Competition post body: ${response.body}");

      if (response.statusCode == 201) {
        return true; // Successfully posted
      } else {
        print(
            "Failed to post competition: ${response.statusCode} - ${response.body}");
        return false; // Failed
      }
    } catch (e) {
      print("Error posting competition: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCompetitions() async {
    const String url = "$baseUrl/competitions/competitions";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print("Error fetching competitions: ${response.body}");
        return []; // Return an empty list instead of null
      }
    } catch (e) {
      print("Exception: $e");
      return []; // Ensure it never returns null
    }
  }
}

Future<bool> deleteCompetition(String id) async {
  final String url = "http://localhost:5500/api/competitions/competitions/$id";

  try {
    final response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      return true; // Successfully deleted
    } else if (response.statusCode == 404) {
      print("Competition not found");
      return false;
    } else {
      print("Error deleting competition: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception: $e");
    return false;
  }
}
