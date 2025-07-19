import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String?> teamData = {};

  @override
  void initState() {
    super.initState();
    loadTeamData();
  }

  Future<void> loadTeamData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      teamData = {
        'teamName': prefs.getString('teamName') ?? "No Team Name",
        'competitionName': prefs.getString('competitionName') ?? "No Competition Name",
        'teamMember1ID': prefs.getString('teamMember1ID') ?? "No ID",
        'teamMember1Name': prefs.getString('teamMember1Name') ?? "No Name",
        'teamMember2ID': prefs.getString('teamMember2ID') ?? "No ID",
        'teamMember2Name': prefs.getString('teamMember2Name') ?? "No Name",
        'date': prefs.getString('date') ?? "No Date",
        'location': prefs.getString('location') ?? "No Location",
        'kind': prefs.getString('kind') ?? "No Kind",
      };
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Contests"),
      backgroundColor: Colors.blue, // Set your desired color here
    ),
    body: ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text(teamData['teamName']!),
            children: <Widget>[
              ListTile(
                title: Text('Competition Name'),
                subtitle: Text(teamData['competitionName']!),
              ),
              ListTile(
                title: Text('Team Member 1 ID'),
                subtitle: Text('${teamData['teamMember1ID']} (${teamData['teamMember1Name']})'),
              ),
              ListTile(
                title: Text('Team Member 2 ID'),
                subtitle: Text('${teamData['teamMember2ID']} (${teamData['teamMember2Name']})'),
              ),
              ListTile(
                title: Text('Location'),
                subtitle: Text(teamData['location']!),
              ),
              ListTile(
                title: Text('Date'),
                subtitle: Text(teamData['date']!),
              ),
              ListTile(
                title: Text('Kind'),
                subtitle: Text(teamData['kind']!),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}