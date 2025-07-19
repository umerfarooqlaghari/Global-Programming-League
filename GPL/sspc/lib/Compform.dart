import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sspc/services/contest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
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

        if (response.statusCode == 200) {
          await saveTeamData(
            teamName: _teamName!,
            competitionName: _selectedCompetition!,
            teamMember1ID: _teamMember1ID!,
            teamMember1Name: _teamMember1Name!,
            teamMember2ID: _teamMember2ID!,
            teamMember2Name: _teamMember2Name!,
            date: _selectedDate!.toIso8601String(),
            location: _location!,
            kind: _selectedKind!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team created successfully!')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
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
    await prefs.setString('teamName', teamName);
    await prefs.setString('competitionName', competitionName);
    await prefs.setString('teamMember1ID', teamMember1ID);
    await prefs.setString('teamMember1Name', teamMember1Name);
    await prefs.setString('teamMember2ID', teamMember2ID);
    await prefs.setString('teamMember2Name', teamMember2Name);
    await prefs.setString('date', date);
    await prefs.setString('location', location);
    await prefs.setString('kind', kind);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Team',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                    border: OutlineInputBorder(),
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Competition Name',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Zab e fest', 'ICPC', 'TechWorld', 'Procom']
                      .map((competition) => DropdownMenuItem(
                            value: competition,
                            child: Text(competition),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCompetition = value;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a competition'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Team Member 1 ID',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]+')),
                  ],
                  onSaved: (value) => _teamMember1ID = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a team member ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Team Member 1 Name',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _teamMember1Name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Team Member 2 ID',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]+')),
                  ],
                  onSaved: (value) => _teamMember2ID = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a team member ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Team Member 2 Name',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _teamMember2Name = value,
                  validator: (value) {
                    if (value == null ||value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
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
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kind',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Worldwide', 'Regional', 'Local']
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
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a kind' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
