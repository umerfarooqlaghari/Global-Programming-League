import 'package:flutter/material.dart';
import 'package:sspc/Userchat.dart';
import 'package:sspc/Userprofile.dart';
import 'package:sspc/Userspastpaper.dart';
import 'package:sspc/competitions.dart';
import 'package:sspc/contest.dart';
import 'package:sspc/contest_view_screen.dart';
import 'package:sspc/login_screen.dart';
import 'package:sspc/payment_gateway.dart';
import 'package:sspc/rank.dart';
import 'package:sspc/viewpastpaper.dart';
import 'index.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userProfilePicture;

  const DashboardScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfilePicture,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A237E),
                Color(0xFF283593),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A237E),
                      Color(0xFF283593),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(widget.userProfilePicture),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group, color: Colors.white),
                title: const Text('Community Forum',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.white),
                title: const Text('User Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.white),
                title: const Text('Your Contests',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContestViewScreen()));
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.leaderboard_outlined, color: Colors.white),
                title: const Text('Rankings',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Rankingsscreens()));
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.description_outlined, color: Colors.white),
                title: const Text('Past Papers',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Userspastpaper()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.white),
                title: const Text('Chat Support',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Chat(userId: widget.userName, isAdmin: false)));
                },
              ),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpcomingCompetitionsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Animated Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 18 : 28, horizontal: isSmallScreen ? 16 : 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFF283593)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1A237E),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: isSmallScreen ? 28 : 36,
                    backgroundImage: NetworkImage(widget.userProfilePicture),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: isSmallScreen ? 14 : 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isSmallScreen ? 15 : 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 22 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          widget.userEmail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Feature List
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen ? double.infinity : 800, // Constrain width on large screens
                ),
                child: isSmallScreen
                  ? ListView(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      children: _buildFeatureList(context, isSmallScreen),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3.5,
                      children: _buildFeatureList(context, isSmallScreen),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList(BuildContext context, bool isSmallScreen) {
    return [
                _featureTile(
                  context,
                  icon: Icons.group,
                  title: 'Community Forum',
                  subtitle: 'Engage with others in discussions.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
                ),
                _featureTile(
                  context,
                  icon: Icons.account_circle,
                  title: 'User Profile',
                  subtitle: 'View your profile.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
                ),
                _featureTile(
                  context,
                  icon: Icons.emoji_events,
                  title: 'Your Contests',
                  subtitle: 'View registered teams.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContestViewScreen())),
                ),
                _featureTile(
                  context,
                  icon: Icons.leaderboard_outlined,
                  title: 'Rankings',
                  subtitle: 'Check leaderboard standings.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Rankingsscreens())),
                ),
                _featureTile(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Past Papers',
                  subtitle: 'Access old papers for practice.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Userspastpaper())),
                ),
                _featureTile(
                  context,
                  icon: Icons.chat,
                  title: 'Chat Support',
                  subtitle: 'Message with admin support.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(userId: widget.userName, isAdmin: false))),
                ),
                _featureTile(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Upcoming Competitions',
                  subtitle: 'View your activity overview.',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingCompetitionsScreen())),
                ),
    ];
  }

  // Feature ListTile Widget
  Widget _featureTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 10, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 22),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 14, horizontal: isSmallScreen ? 14 : 24),
        leading: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A237E), Color(0xFF283593)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A237E).withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
          child: Icon(icon, color: Colors.white, size: isSmallScreen ? 22 : 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 15 : 18,
            color: const Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 13,
            color: Colors.grey[700],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: const Color(0xFF1A237E), size: isSmallScreen ? 16 : 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 22),
        ),
        tileColor: Colors.white,
        hoverColor: const Color(0xFF1A237E).withOpacity(0.07),
      ),
    );
  }
}
