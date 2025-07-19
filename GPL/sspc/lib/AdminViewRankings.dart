import 'package:flutter/material.dart';
import 'package:sspc/services/Ranking_service.dart';

class AdminViewRankings extends StatefulWidget {
  const AdminViewRankings({super.key});

  @override
  State<AdminViewRankings> createState() => _AdminViewRankingsState();
}

class _AdminViewRankingsState extends State<AdminViewRankings> {
  final RankingService _rankingService = RankingService();
  List<Map<String, dynamic>> _allRankings = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAllRankings();
  }

  Future<void> _fetchAllRankings() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final rankings = await _rankingService.getAllRankings();
      setState(() {
        _allRankings = rankings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRankings(String competitionName) async {
    // Show confirmation dialog
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Rankings'),
          content: Text(
            'Are you sure you want to delete rankings for "$competitionName"?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        bool success = await _rankingService.deleteRankings(competitionName);
        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rankings for "$competitionName" deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _fetchAllRankings(); // Refresh the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete rankings'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occurred while deleting rankings'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF88CDF6),
        title: const Text(
          'Posted Rankings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchAllRankings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF88CDF6)),
              ),
            )
          : _hasError
              ? _buildErrorState()
              : _allRankings.isEmpty
                  ? _buildEmptyState()
                  : _buildRankingsList(),
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
            "Error loading rankings",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchAllRankings,
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

  Widget _buildEmptyState() {
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
            "No rankings posted yet",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rankings will appear here once posted",
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allRankings.length,
      itemBuilder: (context, index) {
        final competitionRanking = _allRankings[index];
        final competitionName = competitionRanking['competitionName'] ?? 'Unknown Competition';
        final rankings = List<Map<String, dynamic>>.from(competitionRanking['rankings'] ?? []);
        
        // Sort rankings by position
        rankings.sort((a, b) => (a['position'] ?? 0).compareTo(b['position'] ?? 0));

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFF88CDF6)],
                  stops: [0.7, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // Competition Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF88CDF6), Color(0xFF6BB6FF)],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            competitionName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => _deleteRankings(competitionName),
                        ),
                      ],
                    ),
                  ),
                  // Rankings List
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: rankings.map((ranking) {
                        final position = ranking['position'] ?? 0;
                        final teamName = ranking['name'] ?? 'Unknown Team';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: position <= 3
                                ? _getPositionColor(position).withOpacity(0.1)
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: position <= 3
                                ? Border.all(
                                    color: _getPositionColor(position).withOpacity(0.3),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              // Position Badge
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getPositionColor(position),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getPositionIcon(position),
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    Text(
                                      '$position',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Team Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teamName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: position <= 3
                                            ? _getPositionColor(position)
                                            : const Color(0xFF2D3748),
                                      ),
                                    ),
                                    Text(
                                      _getPositionText(position),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
