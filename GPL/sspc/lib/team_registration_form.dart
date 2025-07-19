import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sspc/services/contest_service.dart';
import 'package:sspc/contest_view_screen.dart';

class TeamRegistrationForm extends StatefulWidget {
  final List<Map<String, dynamic>> competitions;
  final Map<String, dynamic>? selectedCompetition;

  const TeamRegistrationForm({
    Key? key,
    required this.competitions,
    this.selectedCompetition,
  }) : super(key: key);

  @override
  _TeamRegistrationFormState createState() => _TeamRegistrationFormState();
}

class _TeamRegistrationFormState extends State<TeamRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final ContestService _contestService = ContestService();

  String? _selectedCompetition;
  String? _teamName;
  String? _teamMember1ID;
  String? _teamMember2ID;
  String? _teamMember1Name;
  String? _teamMember2Name;
  DateTime? _selectedDate;
  String? _location;
  String? _selectedKind;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCompetition != null) {
      _selectedCompetition = widget.selectedCompetition!["title"];
      _location = widget.selectedCompetition!["location"];
      _selectedDate = DateTime.parse(widget.selectedCompetition!["date"]);
      _selectedKind = widget.selectedCompetition!["kind"];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2C3E50),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // First check if any team member is already registered for this competition
        bool alreadyRegistered =
            await _contestService.checkExistingRegistration(
          competitionName: _selectedCompetition!,
          teamMember1Name: _teamMember1Name!,
          teamMember2Name: _teamMember2Name!,
        );

        // Hide loading indicator
        Navigator.of(context).pop();

        if (alreadyRegistered) {
          _showErrorDialog(
            'Team Already Registered!',
            'One or more team members are already registered for this competition.\n\nPlease check registered teams or use different team members.',
          );
          return;
        }

        // Show loading indicator again for team creation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final response = await _contestService.createTeam(
          competitionName: _selectedCompetition!,
          teamName: _teamName!,
          teamMember1ID: _teamMember1ID!,
          teamMember2ID: _teamMember2ID!,
          teamMember1Name: _teamMember1Name!,
          teamMember2Name: _teamMember2Name!,
          date: _selectedDate!.toIso8601String(),
          location: _location!,
          kind: _selectedKind!,
        );

        // Hide loading indicator
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Team registered successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();

          // Navigate to contest view screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContestViewScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Hide loading indicator if it's still showing
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Team Registration',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Team Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Team Name',
                      prefixIcon: const Icon(Icons.group),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSaved: (value) => _teamName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a team name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Competition Name Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Competition Name',
                      prefixIcon: const Icon(Icons.emoji_events),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    value: _selectedCompetition,
                    items: widget.competitions
                        .map((competition) => DropdownMenuItem<String>(
                              value: competition["title"],
                              child: Text(competition["title"]),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCompetition = value;
                        // Auto-fill other fields if competition is selected
                        final selectedComp = widget.competitions.firstWhere(
                          (comp) => comp["title"] == value,
                          orElse: () => {},
                        );
                        if (selectedComp.isNotEmpty) {
                          _location = selectedComp["location"];
                          _selectedDate = DateTime.parse(selectedComp["date"]);
                          _selectedKind = selectedComp["kind"];
                        }
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a competition'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Team Member 1 ID
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Team Member 1 ID',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]+')),
                    ],
                    onSaved: (value) => _teamMember1ID = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter team member 1 ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Team Member 1 Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Team Member 1 Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSaved: (value) => _teamMember1Name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter team member 1 name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Team Member 2 ID
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Team Member 2 ID',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]+')),
                    ],
                    onSaved: (value) => _teamMember2ID = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter team member 2 ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Team Member 2 Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Team Member 2 Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSaved: (value) => _teamMember2Name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter team member 2 name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    initialValue: _location,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSaved: (value) => _location = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: () => _selectDate(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) =>
                        _selectedDate == null ? 'Please select a date' : null,
                  ),
                  const SizedBox(height: 16),

                  // Kind Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Kind',
                      prefixIcon: const Icon(Icons.public),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    value: _selectedKind,
                    items: ['Local', 'Regional', 'Worldwide']
                        .map((kind) => DropdownMenuItem(
                              value: kind,
                              child: Text(kind),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedKind = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a kind'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Register Team',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
