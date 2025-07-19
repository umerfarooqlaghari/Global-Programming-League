import 'package:flutter/material.dart';
import 'package:sspc/viewpastpaper.dart';
import '../services/pastpaper_service.dart';

class Postpastpapers extends StatefulWidget {
  const Postpastpapers({super.key});

  @override
  State<Postpastpapers> createState() => _PostpastpapersState();
}

class _PostpastpapersState extends State<Postpastpapers> {
  final TextEditingController kindController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Modified _selectDate to restrict past dates
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initial date to today's date
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime(2101), // You can adjust this to a later date if needed
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toIso8601String();
      });
    }
  }

  void handleUpload() async {
    if (_formKey.currentState!.validate()) {
      final success = await PastpaperService.uploadPastPaper(
        kindController.text,
        dateController.text,
        nameController.text,
        linkController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Past paper uploaded successfully')),
        );

        // Clear the fields after upload
        kindController.clear();
        dateController.clear();
        nameController.clear();
        linkController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload. Link might already exist.')),
        );
      }
    }
  }

  void navigateToViewScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewPastPapersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC), // Soft blue background
      appBar: AppBar(
        title: const Text("Upload Past Paper"),
        backgroundColor: const Color(0xFF002D62), // SZABIST navy blue
        elevation: 0,
        centerTitle: true, // Title is centered
        foregroundColor: Colors.white, // Title color is white
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 600, // Responsive fixed width
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  const Text("Post a Past Paper", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: kindController,
                    decoration: InputDecoration(
                      labelText: 'Kind',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter kind of paper' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: 'Date (Select)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter date' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: linkController,
                    decoration: InputDecoration(
                      labelText: 'Link',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter link' : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: handleUpload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text("Upload"),
                      ),
                      TextButton(
                        onPressed: navigateToViewScreen,
                        child: const Text("View Uploaded"),
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
