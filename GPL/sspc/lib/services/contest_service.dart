import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContestService {
  final String baseUrl = 'http://localhost:5500/apii';

  Future<http.Response> createTeam({
    required String competitionName,
    required String teamName,
    required String teamMember1ID,
    required String teamMember2ID,
    required String teamMember1Name,
    required String teamMember2Name,
    required String date,
    required String location,
    required String kind,
  }) async {
    final url = Uri.parse('http://localhost:5500/api/contest/teams');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =
        prefs.getString('userId'); // Fetch user ID from SharedPreferences

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userId ?? '', // Send user ID in Authorization header
        },
        body: jsonEncode({
          'competitionName': competitionName,
          'teamName': teamName,
          'teamMember1ID': teamMember1ID,
          'teamMember2ID': teamMember2ID,
          'teamMember1Name': teamMember1Name,
          'teamMember2Name': teamMember2Name,
          'date': date,
          'location': location,
          'kind': kind,
        }),
      );

      if (response.statusCode == 200) {
        print('Team created successfully: ${response.body}');
        return response;
      } else {
        print('Failed to create team with status: ${response.statusCode}');
        print('Error: ${response.body}');
        return response;
      }
    } catch (e) {
      print('Error in createTeam: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllTeams() async {
    final url = Uri.parse('http://localhost:5500/api/contest/teams');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch teams with status: ${response.statusCode}');
        print('Error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error in getAllTeams: $e');
      return [];
    }
  }

  Future<bool> checkExistingRegistration({
    required String competitionName,
    required String teamMember1Name,
    required String teamMember2Name,
  }) async {
    final url =
        Uri.parse('http://localhost:5500/api/contest/check-registration');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'competitionName': competitionName,
          'teamMember1Name': teamMember1Name,
          'teamMember2Name': teamMember2Name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] ?? false;
      } else {
        print(
            'Failed to check registration with status: ${response.statusCode}');
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in checkExistingRegistration: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUserTeams(String username) async {
    final url =
        Uri.parse('http://localhost:5500/api/contest/user-teams/$username');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch user teams with status: ${response.statusCode}');
        print('Error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error in getUserTeams: $e');
      return [];
    }
  }
}
