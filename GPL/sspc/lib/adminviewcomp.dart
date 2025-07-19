import 'package:flutter/material.dart';
import 'package:sspc/services/admincompetition_service.dart';
import 'package:sspc/services/admincompetition_service.dart'
    as CompetitionsService;

class AdminViewCompetitionsScreen extends StatefulWidget {
  @override
  _AdminViewCompetitionsScreenState createState() =>
      _AdminViewCompetitionsScreenState();
}

class _AdminViewCompetitionsScreenState
    extends State<AdminViewCompetitionsScreen> {
  List<Map<String, dynamic>> _competitions = [];
  bool _isLoading = true; // Track loading state
  bool _hasError = false; // Track error state

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  Future<void> _fetchCompetitions() async {
    try {
      List<Map<String, dynamic>> competitions =
          await CompetitionsService.CompetitionsService.getAllCompetitions();
      setState(() {
        _competitions = competitions;
        _isLoading = false;
        _hasError = competitions.isEmpty; // Error if no competitions found
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _deleteCompetition(String id) async {
    bool success = await CompetitionsService.deleteCompetition(id);
    if (success) {
      setState(() {
        _competitions.removeWhere((competition) => competition["_id"] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Competition deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete competition")),
      );
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Competition"),
        content: Text("Are you sure you want to delete this competition?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCompetition(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin View Competitions")),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : _hasError
              ? Center(
                  child: Text("No competitions found.",
                      style: TextStyle(fontSize: 16, color: Colors.red)))
              : ListView.builder(
                  itemCount: _competitions.length,
                  itemBuilder: (context, index) {
                    final competition = _competitions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text(competition["title"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text("📅 Date: ${competition["date"]}"),
                            Text("📍 Location: ${competition["location"]}"),
                            Text("🏆 Kind: ${competition["kind"]}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(competition["_id"]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
