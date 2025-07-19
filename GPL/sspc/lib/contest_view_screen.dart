import 'package:flutter/material.dart';
import 'package:sspc/services/contest_service.dart';
import 'package:intl/intl.dart';

class ContestViewScreen extends StatefulWidget {
  @override
  _ContestViewScreenState createState() => _ContestViewScreenState();
}

class _ContestViewScreenState extends State<ContestViewScreen> {
  final ContestService _contestService = ContestService();
  List<Map<String, dynamic>> _teams = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    try {
      List<Map<String, dynamic>> teamsData =
          await _contestService.getAllTeams();
      setState(() {
        _teams = teamsData;
        _isLoading = false;
        _hasError = _teams.isEmpty;
      });
    } catch (e) {
      print("Error fetching teams: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _showTeamDetails(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            team['teamName'] ?? 'Unknown Team',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Warning message for duplicate registrations
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Note: Team members cannot register for the same competition multiple times',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDetailCard(
                      'Competition',
                      team['competitionName'] ?? 'N/A',
                      Icons.emoji_events,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailCard(
                      'Team Member 1',
                      team['teamMember1Name'] ??
                          team['teamMember1']?['name'] ??
                          'N/A',
                      Icons.person,
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),

                    _buildDetailCard(
                      'Registration ID (Member 1)',
                      team['teamMember1ID'] ??
                          team['teamMember1']?['id']?.toString() ??
                          'N/A',
                      Icons.confirmation_number,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailCard(
                      'Team Member 2',
                      team['teamMember2Name'] ??
                          team['teamMember2']?['name'] ??
                          'N/A',
                      Icons.person,
                      Colors.green,
                    ),
                    const SizedBox(height: 8),

                    _buildDetailCard(
                      'Registration ID (Member 2)',
                      team['teamMember2ID'] ??
                          team['teamMember2']?['id']?.toString() ??
                          'N/A',
                      Icons.confirmation_number,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailCard(
                      'Location',
                      team['location'] ?? 'N/A',
                      Icons.location_on,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailCard(
                      'Date',
                      team['date'] != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(team['date']))
                          : 'N/A',
                      Icons.calendar_today,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailCard(
                      'Kind',
                      team['kind'] ?? 'N/A',
                      Icons.public,
                      Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Teams"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No teams registered yet.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchTeams,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _teams.length,
                    itemBuilder: (context, index) {
                      final team = _teams[index];
                      return GestureDetector(
                        onTap: () => _showTeamDetails(team),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withOpacity(0.1),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          team['teamName'] ?? 'Unknown Team',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          team['kind'] ?? 'N/A',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.emoji_events,
                                          size: 18, color: Colors.orange),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          team['competitionName'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.group,
                                          size: 18, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${team['teamMember1Name'] ?? 'N/A'} & ${team['teamMember2Name'] ?? 'N/A'}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 18, color: Colors.red),
                                      const SizedBox(width: 8),
                                      Text(
                                        team['location'] ?? 'N/A',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.calendar_today,
                                          size: 18, color: Colors.purple),
                                      const SizedBox(width: 8),
                                      Text(
                                        team['date'] != null
                                            ? DateFormat('MMM dd, yyyy').format(
                                                DateTime.parse(team['date']))
                                            : 'N/A',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Tap for details',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueAccent
                                              .withOpacity(0.7),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color:
                                            Colors.blueAccent.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
