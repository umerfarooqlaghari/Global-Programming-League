import 'package:flutter/material.dart';
import 'package:sspc/services/my_shared_prefences.dart';
import 'package:sspc/services/post_service.dart';

class CommentSection extends StatefulWidget {
  final Map<String, dynamic> post;
  final Function(Map<String, dynamic>, String, String?)? onCommentAdded;

  const CommentSection({required this.post, this.onCommentAdded, Key? key}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late TextEditingController commentController;
  late List<dynamic> comments;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    comments = List.from(widget.post['comments'] ?? []);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addCommentToView(String commentText, String? username) {
    setState(() {
      comments.add({
        'username': username,
        'comment': commentText,
      });
    });
  }

  Future<void> addComment(String commentText) async {
    try {
      String? username = await getUserName();
      await PostService().addComment(widget.post['_id'], commentText, username);
      addCommentToView(commentText, username);
      
      // Call the callback to update parent state
      if (widget.onCommentAdded != null) {
        widget.onCommentAdded!(widget.post, commentText, username);
      }
    } catch (error) {
      print('Error adding comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(
                    comment['username'] ?? 'Unknown User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comment['comment'] ?? ''),
                );
              },
            ),
          ),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: 'Add a comment...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final commentText = commentController.text.trim();
                  if (commentText.isNotEmpty) {
                    addComment(commentText);
                    commentController.clear();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
