import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

class ChatService {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: 'AIzaSyCu7yeA3GYn19Q3gDxw1IGVEwuj-0OgunY',
  );
  Future<void> sendMessage(String message, BuildContext context) async {
    print('model run');

    final messageModel = Message(
      content: message,
      isByMe: 1,
      timestamp: DateTime.now(),
    );
    Provider.of<ChatProvider>(context, listen: false).addMessage(messageModel);

    final prompt = message;
    final content = [Content.text(prompt)];
    print(content);

    try {
      final response = await model.generateContent(content);
      print(response.text);


        final messageModel = Message(
      content:  response.text!,
      isByMe: 0,
      timestamp: DateTime.now(),
    );
    Provider.of<ChatProvider>(context, listen: false).addMessage(messageModel);
    } catch (e) {
      print('Error: $e');

      String errorMessage =
          'An error occurred. Please check your internet connection and try again.';
      if (e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Unable to connect to the AI service. Please check your internet connection and try again.';
      }
      // Map<String, dynamic> errorResponse = {
      //   'content': errorMessage,
      //   'isMe': 'false',
      //   'timestamp': DateTime.now().toString(),
      //   'isError': true,
      // };
      // messages.add(errorResponse);
    }
  }
}
