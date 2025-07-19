import 'package:shared_preferences/shared_preferences.dart';

// Save variables
Future<void> saveUserData(String email, String username, String userId,String Githublink) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('username', username);
  await prefs.setString('userId', userId);
  await prefs.setString('Githublink',Githublink);
}

// Retrieve variables
Future<void> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final username = prefs.getString('username');
  final Githublink=prefs.getString('Githublink');
  print('Email: $email');
  print('Username: $username');
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  return userId;
}

Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  final username= prefs.getString('username');
  return username;


}

 Future<String?> getGithubLink() async {
  final prefs = await SharedPreferences.getInstance();
  final Githublink= prefs.getString('Githublink');
  return Githublink;
 
}


Future<String?> getemail() async {
  final prefs = await SharedPreferences.getInstance();
  final email= prefs.getString('email');
  return email;
}

Future<void> saveTeamData({
  required String teamName,
  required String competitionName,
  required String teamMember1ID,
  required String teamMember1Name,
  required String teamMember2ID,
  required String teamMember2Name,
  required String date,
  required String location,
  required String kind,
}) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Saving team information
  await prefs.setString('teamName', teamName);
  await prefs.setString('competitionName', competitionName);
  
  // Saving team member 1 information
  await prefs.setString('teamMember1ID', teamMember1ID);
  await prefs.setString('teamMember1Name', teamMember1Name);
  
  // Saving team member 2 information
  await prefs.setString('teamMember2ID', teamMember2ID);
  await prefs.setString('teamMember2Name', teamMember2Name);
  
  // Saving other details
  await prefs.setString('date', date);
  await prefs.setString('location', location);
  await prefs.setString('kind', kind);
}

// Retrieve team data
Future<Map<String, String?>> getTeamData() async {
  final prefs = await SharedPreferences.getInstance();
  
  Map<String, String?> teamData = {
    'teamName': prefs.getString('teamName'),
    'competitionName': prefs.getString('competitionName'),
    'teamMember1ID': prefs.getString('teamMember1ID'),
    'teamMember1Name': prefs.getString('teamMember1Name'),
    'teamMember2ID': prefs.getString('teamMember2ID'),
    'teamMember2Name': prefs.getString('teamMember2Name'),
    'date': prefs.getString('date'),
    'location': prefs.getString('location'),
    'kind': prefs.getString('kind'),
  };

  return teamData;
}
