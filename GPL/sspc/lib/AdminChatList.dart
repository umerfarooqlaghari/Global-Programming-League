import 'package:flutter/material.dart';
import 'package:sspc/services/chat_service.dart';
import 'package:sspc/AdminChatConversation.dart';
import 'package:intl/intl.dart';

class AdminChatList extends StatefulWidget {
  final String adminId;

  const AdminChatList({super.key, required this.adminId});

  @override
  State<AdminChatList> createState() => _AdminChatListState();
}

class _AdminChatListState extends State<AdminChatList> {
  final ChatService _chatService = ChatService();
  List<UserConversation> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => isLoading = true);

    try {
      final conversationData = await _chatService.getAllConversations();
      print('Raw conversation data: $conversationData'); // Debug print

      setState(() {
        conversations = conversationData.map((data) {
          print('Processing conversation: $data'); // Debug print
          return UserConversation(
            userId: data['userId'] ?? data['_id'] ?? '',
            username: data['username'] ?? data['userName'] ?? 'Unknown User',
            email: data['email'] ?? '',
            lastMessage: data['lastMessage'] ?? 'No messages yet',
            lastTimestamp: data['lastTimestamp'] != null
                ? DateTime.parse(data['lastTimestamp'])
                : DateTime.now(),
            messageCount: data['messageCount'] ?? 0,
            messages: [],
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error in _loadConversations: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading conversations: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Support'),
        backgroundColor: const Color(0xFF88CDF6),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConversations,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : conversations.isEmpty
                ? _buildEmptyState()
                : _buildChatList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF88CDF6), Color(0xFF5FB0E8)],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Users will appear here when they start chatting with support',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF88CDF6), Color(0xFF5FB0E8)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF88CDF6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _loadConversations,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Refresh',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _buildChatListItem(conversation);
      },
    );
  }

  Widget _buildChatListItem(UserConversation conversation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF88CDF6), Color(0xFF5FB0E8)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF88CDF6).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            child: Text(
              conversation.username.isNotEmpty
                  ? conversation.username[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          conversation.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (conversation.email.isNotEmpty)
              Text(
                conversation.email,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              conversation.lastMessage,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('MMM dd').format(conversation.lastTimestamp),
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF88CDF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.messageCount} msgs',
                style: const TextStyle(
                  color: Color(0xFF88CDF6),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminChatConversation(
                adminId: widget.adminId,
                conversation: conversation,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Data model for UserConversation
class UserConversation {
  final String userId;
  final String username;
  final String email;
  String lastMessage;
  DateTime lastTimestamp;
  final int messageCount;
  List<ChatMessage> messages;

  UserConversation({
    required this.userId,
    required this.username,
    required this.email,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.messageCount,
    required this.messages,
  });
}

// Data model for ChatMessage
class ChatMessage {
  final String senderId;
  final String message;
  final bool isAdmin;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.isAdmin,
    required this.timestamp,
  });
}
