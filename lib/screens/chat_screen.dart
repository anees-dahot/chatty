import 'package:chat_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Chatty',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final data = messages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MessageBubble(
                    message: data['content'],
                    isMe: data['isMe'] == 'true',
                    time: data['timestamp'],
                    isError: data['isError'] ?? false,
                  ),
                );
              },
            ),
          ),
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
                      onSubmitted: (value) {
                        
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
                     final model = GenerativeModel(
                        model: 'gemini-1.5-flash-latest',
                       apiKey: 'AIzaSyCu7yeA3GYn19Q3gDxw1IGVEwuj-0OgunY',
                      );
                      print('model run');

                      Map<String, dynamic> myMessage = {
                        'content': messageController.text,
                        'isMe': 'true',
                        'timestamp': DateTime.now().toString(),
                      };
                      messages.add(myMessage);
                      setState(() {});

                      final prompt = messageController.text;
                      final content = [Content.text(prompt)];
                      print(content);

                      try {
                        final response = await model.generateContent(content);
                        print(response.text);

                        Map<String, dynamic> aiResponse = {
                          'content': response.text,
                          'isMe': 'false',
                          'timestamp': DateTime.now().toString(),
                        };
                        messages.add(aiResponse);
                      } catch (e) {
                        print('Error: $e');

                        String errorMessage =
                            'An error occurred. Please check your internet connection and try again.';
                        if (e.toString().contains('Failed host lookup')) {
                          errorMessage =
                              'Unable to connect to the AI service. Please check your internet connection and try again.';
                        }
                        Map<String, dynamic> errorResponse = {
                          'content': errorMessage,
                          'isMe': 'false',
                          'timestamp': DateTime.now().toString(),
                          'isError': true,
                        };
                        messages.add(errorResponse);
                      }

                      setState(() {
                        // Automatically scroll to the bottom after sending a message.
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });

                      messageController.clear();
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