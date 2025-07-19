import 'package:flutter/material.dart';
import 'package:sspc/Admincompetitions.dart';
import 'package:sspc/Adminpanel.dart';
import 'package:sspc/Adminrankings.dart';
import 'package:sspc/login_screen.dart';
import 'package:sspc/postpastpapers.dart';
import 'package:sspc/AdminChatList.dart';
import 'package:sspc/AdminViewRankings.dart';
import 'package:sspc/adminviewcomp.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sspc/services/Ranking_service.dart';
import 'package:sspc/services/admincompetition_service.dart'
    as CompetitionsService;

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final RankingService _rankingService = RankingService();
  List<Map<String, dynamic>> _allRankings = [];
  List<Map<String, dynamic>> _competitions = [];
  bool _isLoading = true;
  int _totalCompetitions = 0;
  int _totalRankings = 0;
  int _totalTeams = 0;

  final List<Color> cardColors = [
    Color(0xFF4B76B6), // Blue color for consistency
    Color(0xFF76A5F2), // Light blue for contrast
    Color(0xFF2D8B8C), // Aqua color for variety
    Color(0xFF6A4C93), // Purple for variety
  ];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch rankings data
      final rankings = await _rankingService.getAllRankings();

      // Fetch competitions data
      final competitionsData =
          await CompetitionsService.CompetitionsService.getAllCompetitions();

      setState(() {
        _allRankings = rankings;
        _competitions = competitionsData;
        _totalCompetitions = competitionsData.length;
        _totalRankings = rankings.length;
        _totalTeams = _calculateTotalTeams(rankings);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _calculateTotalTeams(List<Map<String, dynamic>> rankings) {
    int total = 0;
    for (var ranking in rankings) {
      if (ranking['rankings'] != null) {
        total += (ranking['rankings'] as List).length;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), // Blue AppBar color
        title: const Text('Admin Dashboard'),
        centerTitle: true, // Center the title
        foregroundColor: Colors.white, // Set title color to white
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF003366), // Sidebar background color
          width: 280, // Adjust drawer width
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text("Admin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                accountEmail: const Text("admin@gmail.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings,
                      color: Color(0xFF003366), size: 30),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF003366),
                ),
              ),
              _createDrawerItem(Icons.dashboard, 'Dashboard', Colors.white,
                  onTap: () {
                Navigator.pop(context);
              }),
              const Divider(color: Colors.white24, height: 1),

              // Rankings Section
              _createDrawerItem(
                  Icons.emoji_events, 'Post Rankings', Colors.white, onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RankingsScreen()));
              }),
              _createDrawerItem(Icons.visibility, 'View Rankings', Colors.white,
                  onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminViewRankings()));
              }),
              const Divider(color: Colors.white24, height: 1),

              // Competitions Section
              _createDrawerItem(
                  Icons.sports_esports, 'Post Competitions', Colors.white,
                  onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostCompetitionsScreen()));
              }),
              _createDrawerItem(
                  Icons.list_alt, 'View Competitions', Colors.white, onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminViewCompetitionsScreen()));
              }),
              const Divider(color: Colors.white24, height: 1),

              // Other Features
              _createDrawerItem(
                  Icons.description, 'Upload Past Papers', Colors.white,
                  onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Postpastpapers()));
              }),
              _createDrawerItem(Icons.chat, 'Chat Support', Colors.white,
                  onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminChatList(adminId: 'admin')));
              }),
              const Divider(color: Colors.white24, height: 1),

              _createDrawerItem(Icons.refresh, 'Refresh Data', Colors.white,
                  onTap: () {
                _fetchDashboardData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Dashboard data refreshed'),
                      backgroundColor: Colors.green),
                );
              }),
              const Divider(color: Colors.white24, height: 1),
              _createDrawerItem(Icons.exit_to_app, 'Logout', Colors.white,
                  onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                );
              }),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 600 ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 600;
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isMobile ? 16 : 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF003366), Color(0xFF4B76B6)],
                            ),
                            borderRadius:
                                BorderRadius.circular(isMobile ? 12 : 16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.admin_panel_settings,
                                      color: Colors.white,
                                      size: isMobile ? 28 : 32),
                                  SizedBox(width: isMobile ? 8 : 12),
                                  Expanded(
                                    child: Text(
                                      'Admin Dashboard',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isMobile ? 20 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 6 : 8),
                              Text(
                                'Welcome back! Here\'s your system overview',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: isMobile ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Statistics Cards
                    _buildStatisticsSection(),
                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActionsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _createDrawerItem(IconData icon, String text, Color textColor,
      {Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Enhanced responsive breakpoints
            int columns;
            double childAspectRatio;

            if (constraints.maxWidth > 1200) {
              // Large desktop
              columns = 4;
              childAspectRatio = 1.4;
            } else if (constraints.maxWidth > 800) {
              // Desktop/tablet landscape
              columns = 4;
              childAspectRatio = 1.2;
            } else if (constraints.maxWidth > 600) {
              // Tablet portrait
              columns = 2;
              childAspectRatio = 1.3;
            } else {
              // Mobile
              columns = 2;
              childAspectRatio = 1.1;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: constraints.maxWidth > 600 ? 12 : 8,
              mainAxisSpacing: constraints.maxWidth > 600 ? 12 : 8,
              childAspectRatio: childAspectRatio,
              children: [
                _buildStatisticCard(
                  'Total Competitions',
                  _totalCompetitions.toString(),
                  Icons.sports_esports,
                  cardColors[0],
                ),
                _buildStatisticCard(
                  'Posted Rankings',
                  _totalRankings.toString(),
                  Icons.emoji_events,
                  cardColors[1],
                ),
                _buildStatisticCard(
                  'Total Teams',
                  _totalTeams.toString(),
                  Icons.groups,
                  cardColors[2],
                ),
                _buildStatisticCard(
                  'Active Features',
                  '6',
                  Icons.dashboard,
                  cardColors[3],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatisticCard(
      String title, String value, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = MediaQuery.of(context).size.width < 600;
        return Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                ),
                child: Icon(icon, color: color, size: isMobile ? 24 : 28),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: isMobile ? 2 : 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Enhanced responsive breakpoints for quick actions
            int columns;
            double childAspectRatio;

            if (constraints.maxWidth > 1200) {
              // Large desktop
              columns = 4;
              childAspectRatio = 1.6;
            } else if (constraints.maxWidth > 800) {
              // Desktop/tablet landscape
              columns = 4;
              childAspectRatio = 1.4;
            } else if (constraints.maxWidth > 600) {
              // Tablet portrait
              columns = 2;
              childAspectRatio = 1.5;
            } else {
              // Mobile
              columns = 2;
              childAspectRatio = 1.2;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: constraints.maxWidth > 600 ? 12 : 8,
              mainAxisSpacing: constraints.maxWidth > 600 ? 12 : 8,
              childAspectRatio: childAspectRatio,
              children: [
                _buildActionCard(
                  'Post Rankings',
                  Icons.emoji_events,
                  cardColors[0],
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RankingsScreen())),
                ),
                _buildActionCard(
                  'Post Competitions',
                  Icons.sports_esports,
                  cardColors[1],
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostCompetitionsScreen())),
                ),
                _buildActionCard(
                  'Upload Papers',
                  Icons.description,
                  cardColors[2],
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Postpastpapers())),
                ),
                _buildActionCard(
                  'Chat Support',
                  Icons.chat,
                  cardColors[3],
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AdminChatList(adminId: 'admin'))),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = MediaQuery.of(context).size.width < 600;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: isMobile ? 28 : 32),
                SizedBox(height: isMobile ? 6 : 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
