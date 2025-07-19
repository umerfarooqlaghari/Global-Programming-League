import 'package:flutter/material.dart';
import 'package:sspc/services/pastpaper_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Userspastpaper extends StatefulWidget {
  const Userspastpaper({super.key});

  @override
  State<Userspastpaper> createState() => _UserspastpaperState();
}

class _UserspastpaperState extends State<Userspastpaper> {
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
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FD),
      appBar: AppBar(
        title: const Text("Past Papers"),
        backgroundColor: const Color(0xFF87CEFA),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text(
                    "No past papers available.",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;

                    // Dynamically set crossAxisCount
                    int crossAxisCount = 2;
                    if (width >= 600) crossAxisCount = 3;
                    if (width >= 900) crossAxisCount = 4;

                    double padding = width * 0.04;
                    double fontSize = width * 0.035; // e.g., 14–18 range
                    double iconSize = width * 0.07;

                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: GridView.builder(
                        itemCount: _pastPapers.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 3 / 3.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final paper = _pastPapers[index];
                          return InkWell(
                            onTap: () => _launchURL(paper["link"] ?? ""),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(2, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.picture_as_pdf,
                                      color: Colors.blueAccent, size: iconSize),
                                  SizedBox(height: padding / 2),
                                  Text(
                                    paper["name"] ?? "Untitled",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: padding / 3),
                                  Text(
                                    "📅 ${paper["date"]?.substring(0, 10) ?? "N/A"}",
                                    style: TextStyle(fontSize: fontSize * 0.9),
                                  ),
                                  Text(
                                    "📂 ${paper["kind"] ?? "Unknown"}",
                                    style: TextStyle(fontSize: fontSize * 0.9),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Tap to open",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: fontSize * 0.9,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
