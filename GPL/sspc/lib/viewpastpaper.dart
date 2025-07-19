import 'package:flutter/material.dart';
import 'package:sspc/services/pastpaper_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPastPapersScreen extends StatefulWidget {
  @override
  _ViewPastPapersScreenState createState() => _ViewPastPapersScreenState();
}

class _ViewPastPapersScreenState extends State<ViewPastPapersScreen> {
  List<Map<String, dynamic>> _pastPapers = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPastPapers();
  }

  Future<void> _fetchPastPapers() async {
    try {
      List<Map<String, dynamic>> pastPapers = await PastpaperService.getPastPapers();
      setState(() {
        _pastPapers = pastPapers;
        _isLoading = false;
        _hasError = pastPapers.isEmpty;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  Future<void> _deletePastPaper(String id) async {
    bool success = await PastpaperService.deletePastPaper(id);
    if (success) {
      setState(() {
        _pastPapers.removeWhere((paper) => paper["_id"] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Past paper deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete past paper")),
      );
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Past Paper"),
        content: Text("Are you sure you want to delete this past paper?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePastPaper(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FD), // Soft background color
      appBar: AppBar(
        title: const Text("View Past Papers"),
        backgroundColor: const Color(0xFF003366), // Blue app bar
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white, // White text color
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text(
                    "No past papers found.",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: _pastPapers.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cards per row (like Admin Dashboard)
                      childAspectRatio: 1.5, // Adjusted for smaller cards
                      crossAxisSpacing: 10, // Spacing between cards
                      mainAxisSpacing: 10,  // Vertical spacing between cards
                    ),
                    itemBuilder: (context, index) {
                      final paper = _pastPapers[index];
                      return InkWell(
                        onTap: () => _launchURL(paper["link"] ?? ""),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.picture_as_pdf, color: Colors.blueAccent, size: 30),
                              const SizedBox(height: 10),
                              Text(
                                paper["name"] ?? "Untitled",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text("📅 ${paper["date"]?.substring(0, 10) ?? "N/A"}"),
                              Text("📂 ${paper["kind"] ?? "Unknown"}"),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Tap to open", style: TextStyle(color: Colors.blueAccent)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDelete(paper["_id"]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
