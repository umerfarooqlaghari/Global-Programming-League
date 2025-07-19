import 'package:flutter/material.dart';
import 'package:sspc/services/Ranking_service.dart';
import 'package:sspc/services/admincompetition_service.dart'
    as CompetitionsService;

class Rankingsscreens extends StatefulWidget {
  const Rankingsscreens({super.key});

  @override
  State<Rankingsscreens> createState() => _RankingsscreensState();
}

class _RankingsscreensState extends State<Rankingsscreens>
    with TickerProviderStateMixin {
  final RankingService _rankingService = RankingService();
  List<String> _competitions = [];
  List<Map<String, dynamic>> _rankingsList = [];
  bool _isLoadingCompetitions = true;
  bool _isLoadingRankings = false;
  bool _hasError = false;
  String? selectedCompetition;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fetchCompetitions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCompetitions() async {
    setState(() {
      _isLoadingCompetitions = true;
      _hasError = false;
    });

    try {
      List<Map<String, dynamic>> competitions =
          await CompetitionsService.CompetitionsService.getAllCompetitions();

      setState(() {
        _competitions =
            competitions.map((comp) => comp["title"].toString()).toList();
        _isLoadingCompetitions = false;
        _hasError = _competitions.isEmpty;
      });
    } catch (e) {
      print("Error fetching competitions: $e");
      setState(() {
        _isLoadingCompetitions = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchRankings(String competitionName) async {
    setState(() {
      _isLoadingRankings = true;
      selectedCompetition = competitionName;
      _rankingsList = [];
    });

    _animationController.reset();

    try {
      final normalizedName = competitionName.toLowerCase().trim();
      print("Fetching rankings for: $normalizedName");

      List<Map<String, dynamic>> rankings =
          await _rankingService.getRankings(normalizedName);

      setState(() {
        _rankingsList = rankings;
        _isLoadingRankings = false;
      });

      if (rankings.isNotEmpty) {
        _animationController.forward();
      }
    } catch (e) {
      print("Error fetching rankings: $e");
      setState(() {
        _isLoadingRankings = false;
      });
    }
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF88CDF6); // Default blue
    }
  }

  IconData _getPositionIcon(int position) {
    switch (position) {
      case 1:
        return Icons.emoji_events; // Trophy
      case 2:
        return Icons.military_tech; // Medal
      case 3:
        return Icons.military_tech; // Medal
      default:
        return Icons.star; // Star for other positions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF88CDF6),
        title: const Text(
          'Competition Rankings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: selectedCompetition != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedCompetition = null;
                    _rankingsList = [];
                  });
                },
              )
            : null,
      ),
      body: _isLoadingCompetitions
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF88CDF6)),
              ),
            )
          : _hasError
              ? _buildErrorState()
              : selectedCompetition == null
                  ? _buildCompetitionsList()
                  : _buildRankingsView(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No competitions available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCompetitions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF88CDF6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionsList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF88CDF6), Color(0xFF6BB6FF)],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                size: 48,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 12),
              const Text(
                "Select a Competition",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Choose from ${_competitions.length} available competitions",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _competitions.length,
            itemBuilder: (context, index) {
              final competitionName = _competitions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _fetchRankings(competitionName);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            const Color(0xFF88CDF6).withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF88CDF6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sports_esports,
                              color: Color(0xFF88CDF6),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  competitionName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Tap to view rankings",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF88CDF6),
                            size: 20,
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
      ],
    );
  }

  Widget _buildRankingsView() {
    return Column(
      children: [
        // Competition Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF88CDF6), Color(0xFF6BB6FF)],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 12),
              Text(
                selectedCompetition ?? "Competition",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Rankings",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Rankings Content
        Expanded(
          child: _isLoadingRankings
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF88CDF6)),
                  ),
                )
              : _rankingsList.isEmpty
                  ? _buildEmptyRankings()
                  : _buildRankingsList(),
        ),
      ],
    );
  }

  Widget _buildEmptyRankings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.leaderboard,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No rankings available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rankings for this competition haven't been posted yet",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsList() {
    // Sort rankings by position
    final sortedRankings = List<Map<String, dynamic>>.from(_rankingsList);
    sortedRankings
        .sort((a, b) => (a['position'] ?? 0).compareTo(b['position'] ?? 0));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedRankings.length,
        itemBuilder: (context, index) {
          final ranking = sortedRankings[index];
          final position = ranking['position'] ?? 0;
          final teamName = ranking['name'] ?? 'Unknown Team';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              elevation: position <= 3 ? 8 : 4,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: position <= 3
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getPositionColor(position).withOpacity(0.1),
                            _getPositionColor(position).withOpacity(0.05),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            const Color(0xFF88CDF6).withOpacity(0.02),
                          ],
                        ),
                  border: position <= 3
                      ? Border.all(
                          color: _getPositionColor(position).withOpacity(0.3),
                          width: 2,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    // Position Badge
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getPositionColor(position),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _getPositionColor(position).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getPositionIcon(position),
                            color: Colors.white,
                            size: position <= 3 ? 24 : 20,
                          ),
                          Text(
                            '$position',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Team Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: position <= 3
                                  ? _getPositionColor(position)
                                  : const Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getPositionText(position),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Position Indicator
                    if (position <= 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getPositionColor(position).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getPositionLabel(position),
                          style: TextStyle(
                            color: _getPositionColor(position),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPositionText(int position) {
    switch (position) {
      case 1:
        return "🏆 Champion";
      case 2:
        return "🥈 Runner-up";
      case 3:
        return "🥉 Third Place";
      default:
        return "Position $position";
    }
  }

  String _getPositionLabel(int position) {
    switch (position) {
      case 1:
        return "WINNER";
      case 2:
        return "2ND";
      case 3:
        return "3RD";
      default:
        return "${position}TH";
    }
  }
}
