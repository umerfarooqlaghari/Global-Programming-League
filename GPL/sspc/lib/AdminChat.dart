import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sspc/services/chat_service.dart';
import 'package:sspc/config/app_config.dart';

class AdminChat extends StatefulWidget {
  final String adminId;

  const AdminChat({super.key, required this.adminId});

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> with TickerProviderStateMixin {
  late IO.Socket socket;
  TabController? _tabController;
  final ChatService _chatService = ChatService();

  List<UserConversation> conversations = [];
  bool isLoading = true;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _connectSocket();
  }

  Future<void> _loadConversations() async {
    setState(() => isLoading = true);

    try {
      final conversationData = await _chatService.getAllConversations();

      setState(() {
        conversations = conversationData.map((data) => UserConversation(
          userId: data['userId'] ?? '',
          username: data['username'] ?? 'Unknown User',
          email: data['email'] ?? '',
          lastMessage: data['lastMessage'] ?? '',
          lastTimestamp: DateTime.parse(data['lastTimestamp'] ?? DateTime.now().toIso8601String()),
          messageCount: data['messageCount'] ?? 0,
          messages: [],
        )).toList();

        if (conversations.isNotEmpty) {
          _tabController?.dispose(); // Dispose previous controller if exists
          _tabController = TabController(length: conversations.length, vsync: this);
          _loadMessagesForCurrentTab();
        }
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

  Future<void> _loadMessagesForCurrentTab() async {
    if (conversations.isEmpty) return;

    final currentConversation = conversations[currentTabIndex];
    final messages = await _chatService.getConversation(currentConversation.userId);

    setState(() {
      conversations[currentTabIndex].messages = messages.map((data) => ChatMessage(
        senderId: data['senderId'] ?? '',
        message: data['message'] ?? '',
        isAdmin: data['isAdmin'] ?? false,
        timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
      )).toList();
    });
  }

  void _connectSocket() {
    socket = IO.io(AppConfig.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((_) {
      socket.emit('joinAdmin');
    });

    socket.on('receiveMessage', (data) {
      _handleNewMessage(data);
    });
  }

  void _handleNewMessage(dynamic data) {
    final newMessage = ChatMessage(
      senderId: data['senderId'] ?? '',
      message: data['message'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );

    setState(() {
      // Find the conversation for this user
      final conversationIndex = conversations.indexWhere(
        (conv) => conv.userId == newMessage.senderId ||
                 (newMessage.isAdmin && conv.userId == data['receiverId'])
      );

      if (conversationIndex != -1) {
        conversations[conversationIndex].messages.add(newMessage);
        conversations[conversationIndex].lastMessage = newMessage.message;
        conversations[conversationIndex].lastTimestamp = newMessage.timestamp;
      }
    });
  }

  void _sendMessage(String messageText) {
    if (messageText.isNotEmpty && conversations.isNotEmpty) {
      final currentConversation = conversations[currentTabIndex];

      final newMessage = ChatMessage(
        senderId: widget.adminId,
        message: messageText,
        isAdmin: true,
        timestamp: DateTime.now(),
      );

      setState(() {
        currentConversation.messages.add(newMessage);
        currentConversation.lastMessage = messageText;
        currentConversation.lastTimestamp = DateTime.now();
      });

      socket.emit('sendMessage', {
        'senderId': widget.adminId,
        'receiverId': currentConversation.userId,
        'message': messageText,
        'isAdmin': true,
      });
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Chat Support'),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (conversations.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Chat Support'),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'No conversations yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Users will appear here when they start chatting',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadConversations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: conversations.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Chat Support'),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            onTap: (index) {
              setState(() {
                currentTabIndex = index;
              });
              _loadMessagesForCurrentTab();
            },
            tabs: conversations.map((conv) => Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(conv.username, style: const TextStyle(fontSize: 12)),
                  Text('(${conv.messages.length})', style: const TextStyle(fontSize: 10)),
                ],
              ),
            )).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: conversations.map((conversation) =>
            _buildChatView(conversation)
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildChatView(UserConversation conversation) {
    final messageController = TextEditingController();

    return Column(
      children: [
        // User info header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          color: const Color(0xFF4B76B6).withOpacity(0.1),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF003366),
                child: Text(
                  conversation.username.isNotEmpty ? conversation.username[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      conversation.email,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '${conversation.messages.length} messages',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: conversation.messages.length,
            itemBuilder: (context, index) {
              final message = conversation.messages[index];
              return AdminMessageBubble(
                message: message,
                isMe: message.senderId == widget.adminId,
              );
            },
          ),
        ),
        // Message input
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Reply to ${conversation.username}...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  if (messageController.text.isNotEmpty) {
                    _sendMessage(messageController.text);
                    messageController.clear();
                  }
                },
                mini: true,
                backgroundColor: const Color(0xFF003366),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const AdminMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              isMe ? 'Admin' : 'User: ${message.senderId}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Message bubble
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data models
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
