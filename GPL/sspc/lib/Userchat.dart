// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sspc/services/chat_service.dart';
import 'package:sspc/config/app_config.dart';

class Chat extends StatefulWidget {
  final String userId;
  final bool isAdmin;

  const Chat({super.key, required this.userId, required this.isAdmin});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IO.Socket socket;
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessageHistory();
    connectSocket();
  }

  Future<void> _loadMessageHistory() async {
    try {
      final messageData = await _chatService.getConversation(widget.userId);
      setState(() {
        messages = messageData.map((data) => Message(
          senderId: data['senderId'] ?? '',
          message: data['message'] ?? '',
          isAdmin: data['isAdmin'] ?? false,
          timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
        )).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages: $e')),
        );
      }
    }
  }

  void connectSocket() {
    socket = IO.io(AppConfig.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((_) {
      print('Connected');
      socket.emit('join', widget.userId);
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(Message(
          senderId: data['senderId'],
          message: data['message'],
          isAdmin: data['isAdmin'],
          timestamp: data['timestamp'] != null
            ? DateTime.parse(data['timestamp'])
            : DateTime.now(),
        ));
      });
    });
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = _controller.text;

      // Add message to local list immediately for better UX
      setState(() {
        messages.add(Message(
          senderId: widget.userId,
          message: message,
          isAdmin: widget.isAdmin,
          timestamp: DateTime.now(),
        ));
      });

      socket.emit('sendMessage', {
        'senderId': widget.userId,
        'receiverId': widget.isAdmin ? 'all_users' : 'admin',
        'message': message,
        'isAdmin': widget.isAdmin,
      });
      _controller.clear();
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
      ),
      body: Column(
        children: [
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        'Start a conversation with admin',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageBubble(
                          message: message,
                          isMe: message.senderId == widget.userId,
                        );
                      },
                    ),
            ),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
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
                  onPressed: sendMessage,
                  mini: true,
                  backgroundColor: const Color(0xFF88CDF6),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class Message {
  final String senderId;
  final String message;
  final bool isAdmin;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.isAdmin,
    required this.timestamp,
  });
}