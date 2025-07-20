import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sspc/adminviewcomp.dart';
import 'package:sspc/services/admincompetition_service.dart';

class PostCompetitionsScreen extends StatefulWidget {
  @override
  _PostCompetitionsScreenState createState() => _PostCompetitionsScreenState();
}

class _PostCompetitionsScreenState extends State<PostCompetitionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedKind;

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
    }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Additional validation for date and kind
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      if (_selectedKind == null || _selectedKind!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a kind')),
        );
        return;
      }

      final competitionData = {
        "title": _titleController.text,
        "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
        "location": _locationController.text,
        "kind": _selectedKind ?? '',
      };

      print("Submitting competition data: $competitionData");

      bool success = await CompetitionsService.postCompetition(competitionData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Competition posted successfully!')),
        );
        _formKey.currentState!.reset();
        _titleController.clear();
        _locationController.clear();
        setState(() {
          _selectedDate = null;
          _selectedKind = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post competition')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), // Blue AppBar color
        title: const Text("Post Competition"),
        centerTitle: true, // Center the title
        foregroundColor: Colors.white, // Set title color to white
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Post a Competition",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        labelText: "Title", border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Enter competition title" : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "Select Date"
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                        labelText: "Location", border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Enter location" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedKind,
                    decoration: const InputDecoration(
                      labelText: "Kind",
                      border: OutlineInputBorder(),
                    ),
                    items: ['Local', 'Regional', 'Worldwide']
                        .map((kind) => DropdownMenuItem<String>(
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
                        ? "Please select a kind"
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text("Post Competition"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 231, 231, 231)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminViewCompetitionsScreen()),
                          );
                        },
                        child: const Text("View Competitions"),
                      ),
                    ],
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
