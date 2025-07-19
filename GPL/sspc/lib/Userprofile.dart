import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sspc/services/user_services..dart';
import 'package:sspc/services/contest_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  bool isLoading = false;
  String? teamName;
  String? teamMember1Name;
  String? teamMember2Name;
  List<Map<String, dynamic>> userTeams = [];
  bool isLoadingTeams = false;
  String? displayUsername;
  String? displayEmail;
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isCurrentUser = true; // Track if viewing current user or searched user

  // Loading state indicator
  final UserService userService = UserService(); // Backend API integration
  final ContestService contestService = ContestService();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController searchController =
      TextEditingController(); // For user search

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTeamData();
    _loadUserTeams();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      displayUsername = username;
      displayEmail = email;
    });

    // Load user profile data including profile picture
    if (username != null) {
      try {
        final userInfo = await userService.getUser(username!);
        if (userInfo != null) {
          setState(() {
            _profileImageUrl = userInfo['profilePicture'];
            aboutMeController.text = userInfo['aboutMe'] ?? '';
          });
        }
      } catch (e) {
        print('Error loading user profile data: $e');
      }
      _loadUserTeams();
    }
  }

  Future<void> _loadTeamData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      teamName = prefs.getString('teamName');
      teamMember1Name = prefs.getString('teamMember1Name');
      teamMember2Name = prefs.getString('teamMember2Name');
    });
  }

  Future<void> _loadUserTeams() async {
    String? currentUsername = displayUsername ?? username;
    if (currentUsername == null) return;

    setState(() {
      isLoadingTeams = true;
    });

    try {
      final teams = await contestService.getUserTeams(currentUsername);
      setState(() {
        userTeams = teams;
        isLoadingTeams = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTeams = false;
      });
      print('Error loading user teams: $e');
    }
  }

  Future<void> _fetchUserByUsername(String username) async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final userInfo = await userService.getUser(username);
      if (userInfo != null) {
        setState(() {
          displayUsername = userInfo['username'];
          displayEmail = userInfo['email'];
          aboutMeController.text =
              userInfo['aboutMe'] ?? ''; // Adjust based on your JSON key
          _profileImageUrl = userInfo['profilePicture'];
          _isCurrentUser =
              (userInfo['username'] == username); // Check if it's current user
          isLoading = false; // Stop loading
        });
        // Load teams for the searched user
        _loadUserTeams();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with username: $username')),
        );
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user info: $e')),
      );
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _saveAboutMe() {
    if (aboutMeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('About Me section cannot be empty!')),
      );
      return;
    }

    userService.updateUser(aboutMeController.text).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user info: $e')),
      );
    });
  }

  Future<void> _pickProfileImage() async {
    if (!_isCurrentUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You can only edit your own profile picture')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });

        // Upload the image
        await _uploadProfileImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _removeProfileImage() async {
    if (!_isCurrentUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You can only edit your own profile picture')),
      );
      return;
    }

    try {
      final success = await userService.removeProfilePicture();
      if (success && mounted) {
        setState(() {
          _profileImage = null;
          _profileImageUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile picture removed successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove profile picture')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing image: $e')),
        );
      }
    }
  }

  void _showProfileImageOptions() {
    if (!_isCurrentUser) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
              if (_profileImage != null || _profileImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Profile Picture'),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfileImage();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      final success = await userService.uploadProfilePicture(_profileImage!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile picture updated successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile picture')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    aboutMeController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by username...',
                    hintStyle: TextStyle(color: Color(0xFF64748B)),
                    icon: Icon(Icons.search, color: Color(0xFF3498DB)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _fetchUserByUsername,
                ),
              ),
            ),
            isLoading
                ? SliverFillRemaining(
                    child: Center(
                        child:
                            CircularProgressIndicator()), // Show loading indicator
                  )
                : SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: const Color(0xFF2C3E50),
                              child: const Opacity(
                                opacity: 0.1,
                                child: FlutterLogo(size: 100),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: -50,
                              child: GestureDetector(
                                onTap: _isCurrentUser
                                    ? _showProfileImageOptions
                                    : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: _profileImage != null
                                            ? FileImage(_profileImage!)
                                            : _profileImageUrl != null
                                                ? NetworkImage(
                                                    'http://localhost:5500${_profileImageUrl!}')
                                                : const AssetImage(
                                                        'assets/images/Anas.jpg')
                                                    as ImageProvider,
                                      ),
                                      if (_isCurrentUser)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3498DB),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayUsername ?? 'Loading username...',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              Text(
                                displayEmail ?? 'Loading email...',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: const Color(0xFF64748B),
                                indicator: BoxDecoration(
                                  color: const Color(0xFF3498DB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tabs: const [
                                  Tab(text: 'User Info'),
                                  Tab(text: 'Team'),
                                  Tab(text: 'GitHub ID'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 400,
                                child: TabBarView(
                                  children: [
                                    _buildUserInfoTab(context),
                                    _buildEnhancedTeamTab(),
                                    const Center(
                                      child: Text(
                                        'GitHub link',
                                        style:
                                            TextStyle(color: Color(0xFF475569)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3498DB).withOpacity(0.1),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: const Color(0xFF3498DB).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3498DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ABOUT ME',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Share your background, interests, and what you bring to this community. Express yourself!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Text Field Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: aboutMeController,
              maxLines: 4,
              readOnly: !_isCurrentUser,
              decoration: InputDecoration(
                hintText: _isCurrentUser
                    ? 'Write something about yourself...'
                    : 'User information',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF3498DB), width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Save Button - only show for current user
          if (_isCurrentUser)
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3498DB).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveAboutMe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTeamTab() {
    if (isLoadingTeams) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
        ),
      );
    }

    if (userTeams.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_off,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Teams Found',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This user hasn\'t joined any teams yet',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: userTeams.length,
      itemBuilder: (context, index) {
        final team = userTeams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3498DB).withOpacity(0.1),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Name Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3498DB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          team['teamName'] ?? 'Unknown Team',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Competition Name
                  _buildTeamDetailRow(
                    'Competition',
                    team['competitionName'] ?? 'N/A',
                    Icons.emoji_events,
                    const Color(0xFFE67E22),
                  ),
                  const SizedBox(height: 12),

                  // Team Members
                  _buildTeamDetailRow(
                    'Team Member 1',
                    team['teamMember1Name'] ??
                        team['teamMember1']?['name'] ??
                        'N/A',
                    Icons.person,
                    const Color(0xFF3498DB),
                  ),
                  const SizedBox(height: 8),

                  _buildTeamDetailRow(
                    'Registration ID (Member 1)',
                    team['teamMember1ID'] ?? 'N/A',
                    Icons.confirmation_number,
                    const Color(0xFF9B59B6),
                  ),
                  const SizedBox(height: 12),

                  _buildTeamDetailRow(
                    'Team Member 2',
                    team['teamMember2Name'] ??
                        team['teamMember2']?['name'] ??
                        'N/A',
                    Icons.person,
                    const Color(0xFF27AE60),
                  ),
                  const SizedBox(height: 8),

                  _buildTeamDetailRow(
                    'Registration ID (Member 2)',
                    team['teamMember2ID'] ?? 'N/A',
                    Icons.confirmation_number,
                    const Color(0xFF9B59B6),
                  ),
                  const SizedBox(height: 12),

                  // Additional Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildTeamDetailRow(
                          'Location',
                          team['location'] ?? 'N/A',
                          Icons.location_on,
                          const Color(0xFFE74C3C),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTeamDetailRow(
                          'Type',
                          team['kind'] ?? 'N/A',
                          Icons.category,
                          const Color(0xFF34495E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamDetailRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
