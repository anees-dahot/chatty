import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/provider/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadMessages();
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820), // Modern dark theme
      appBar: AppBar(
        title: const Text(
          'Chatty',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1F2937), // Darker top bar
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MessageBubble(
                        message: message.content,
                        isMe: message.isByMe == 1 ? true : false,
                        time: message.timestamp,
                        isError: message.isError == 1 ? true : false,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Typing indicator with animated dots
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Visibility(
                visible: chatProvider.isTyping, // Show only if typing is true
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 4,
                      ),
                      SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          'Typing${'...'}', // Show dots based on _dotCount
                       
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Message input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      onSubmitted: (value) async {
                        messageController.clear();
                        await chatService.sendMessage(value, context);
                      },
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () async {
                      final content = messageController.text.trim();
                      if (content.isNotEmpty) {
                        messageController.clear();
                        chatService.sendMessage(content, context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
