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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chatty',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final data = messages[index];
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: MessageBubble(
                    message: data['content'],
                    isMe: data['isMe'] == 'true' ? true : false,
                    time: data['timestamp']),
              );
            },
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
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
                        'timestamp': '12:22'
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
                          'timestamp': '12:22'
                        };
                        messages.add(aiResponse);
                      } catch (e) {
                        print('Error: $e');
                        String errorMessage = 'An error occurred. Please check your internet connection and try again.';
                        if (e.toString().contains('Failed host lookup')) {
                          errorMessage = 'Unable to connect to the AI service. Please check your internet connection and try again.';
                        }
                        Map<String, dynamic> errorResponse = {
                          'content': errorMessage,
                          'isMe': 'false',
                          'timestamp': '12:22',
                          'isError': true
                        };
                        messages.add(errorResponse);
                      }
                      setState(() {});
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

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final bool isError;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isError ? Colors.red[100] : (isMe ? Colors.blue[500] : Colors.white),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red[900] : (isMe ? Colors.white : Colors.black87),
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
