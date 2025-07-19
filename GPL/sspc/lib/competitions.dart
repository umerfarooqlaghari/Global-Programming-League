import 'package:flutter/material.dart';
import 'package:sspc/services/admincompetition_service.dart'
    as CompetitionsService;
import 'package:sspc/team_registration_form.dart';

class UpcomingCompetitionsScreen extends StatefulWidget {
  @override
  _UpcomingCompetitionsScreenState createState() =>
      _UpcomingCompetitionsScreenState();
}

class _UpcomingCompetitionsScreenState
    extends State<UpcomingCompetitionsScreen> {
  List<Map<String, dynamic>> _competitions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  Future<void> _fetchCompetitions() async {
    try {
      List<Map<String, dynamic>> competitionsData =
          await CompetitionsService.CompetitionsService.getAllCompetitions();

      setState(() {
        _competitions = competitionsData;
        _isLoading = false;
        _hasError = _competitions.isEmpty;
      });
    } catch (e) {
      print("Error fetching competitions: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _showTeamRegistrationForm(
      BuildContext context, Map<String, dynamic> competition) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TeamRegistrationForm(
          competitions: _competitions,
          selectedCompetition: competition,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Competitions"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : _hasError
              ? const Center(
                  child: Text("No competitions found.",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _competitions.length,
                  itemBuilder: (context, index) {
                    final competition = _competitions[index];
                    return GestureDetector(
                      onTap: () {
                        _showTeamRegistrationForm(context, competition);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  competition["date"]
                                      .split("-")[0], // Extracting day
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      competition["title"],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 4),
                                        Text(competition["date"]),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 4),
                                        Text(competition["location"]),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.emoji_events,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 4),
                                        Text(competition["kind"]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.blueGrey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
