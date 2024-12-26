
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
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
      visible: chatProvider.isTyping,
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 4,
            ),
            SizedBox(width: 8),
            TypingIndicator(), // Replace with the new TypingIndicator widget
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


class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _getOpacityForDot(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  double _getOpacityForDot(int index) {
    double progress = (_controller.value * 3 - index).clamp(0.0, 1.0);
    return 1.0 - progress;
  }
}

