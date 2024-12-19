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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.loadMessages();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), // Fixed duration
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Chatty',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Light theme app bar
        elevation: 1,
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                onPressed: () {
                  chatProvider.deleteMessages();
                },
                icon: const Icon(Icons.delete),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  controller: scrollController,
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
                            color: Colors.black,
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
            color: Colors.white, // Light background
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100], // Light gray input background
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.grey[300]!), // Subtle border
                    ),
                    child: TextField(
                      onSubmitted: (value) async {
                        messageController.clear();
                        _scrollToBottom();
                        await chatService.sendMessage(value, context);
                      },
                      controller: messageController,
                      style: const TextStyle(color: Colors.black), // Dark text
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
                        _scrollToBottom();

                        await chatService.sendMessage(content, context);
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
