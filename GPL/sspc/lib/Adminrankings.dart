import 'package:flutter/material.dart';
import 'package:sspc/services/Ranking_service.dart';
import 'package:sspc/services/admincompetition_service.dart'
    as CompetitionsService;
import 'package:sspc/AdminViewRankings.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  final RankingService _rankingService = RankingService();
  List<Map<String, dynamic>> _rankings = [];

  List<String> _competitions = [];
  String? _selectedCompetition;
  bool _isLoadingCompetitions = true;

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  Future<void> _fetchCompetitions() async {
    try {
      final data =
          await CompetitionsService.CompetitionsService.getAllCompetitions();
      setState(() {
        _competitions = data.map((comp) => comp["title"].toString()).toList();
        _isLoadingCompetitions = false;
      });
    } catch (e) {
      print("Error fetching competitions: $e");
      setState(() {
        _isLoadingCompetitions = false;
      });
    }
  }

  void _addRankingField() {
    setState(() {
      // Set default position to the next available position
      int nextPosition = _rankings.length + 1;
      _rankings.add({"name": "", "position": nextPosition});
    });
  }

  void _updateRanking(int index, String field, dynamic value) {
    setState(() {
      if (field == "position") {
        // Only update if the value is a valid positive integer
        int? parsedValue = int.tryParse(value);
        if (parsedValue != null && parsedValue > 0) {
          _rankings[index][field] = parsedValue;
        }
        // If parsing fails or value is 0 or negative, keep the current value
      } else {
        _rankings[index][field] = value;
      }
    });
  }

  Future<void> _submitRankings() async {
    if (_selectedCompetition == null || _rankings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select competition and enter rankings")),
      );
      return;
    }

    // Validate that all rankings have valid positions and names
    for (int i = 0; i < _rankings.length; i++) {
      if (_rankings[i]["name"] == null ||
          _rankings[i]["name"].toString().trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Please enter team name for position ${i + 1}")),
        );
        return;
      }
      if (_rankings[i]["position"] == null || _rankings[i]["position"] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Please enter valid position for team ${_rankings[i]["name"]}")),
        );
        return;
      }
    }

    final competitionName = _selectedCompetition!.trim().toLowerCase();

    bool success = await _rankingService.postRankings(
      competitionName,
      _rankings,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rankings posted successfully")),
      );
      setState(() {
        _selectedCompetition = null;
        _rankings.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error posting rankings")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), // Blue AppBar color
        title: const Text('Post Rankings'),
        centerTitle: true, // Centering the title
        foregroundColor: Colors.white, // Set the title color to white
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.white),
            tooltip: 'View Posted Rankings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminViewRankings(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _isLoadingCompetitions
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Post Rankings",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCompetition,
                        items: _competitions
                            .map((comp) => DropdownMenuItem(
                                value: comp, child: Text(comp)))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedCompetition = val),
                        decoration: const InputDecoration(
                          labelText: "Select Competition",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._rankings.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      labelText: "Team name",
                                      border: OutlineInputBorder()),
                                  onChanged: (value) =>
                                      _updateRanking(index, "name", value),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelText: "Position",
                                      hintText:
                                          "${_rankings[index]["position"]}",
                                      border: const OutlineInputBorder()),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                    text:
                                        _rankings[index]["position"].toString(),
                                  ),
                                  onChanged: (value) =>
                                      _updateRanking(index, "position", value),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addRankingField,
                        child: const Text("Add Team"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 231, 231, 231)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitRankings,
                        child: const Text("Submit Rankings"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 231, 231, 231)),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
