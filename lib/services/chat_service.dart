// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

class ChatService {
  final model = GenerativeModel(
    model: 'gemini-2.0-flash-exp',
    apiKey: 'AIzaSyCu7yeA3GYn19Q3gDxw1IGVEwuj-0OgunY',
  );
  Future<void> sendMessage(String message, BuildContext context) async {
    final messageModel = Message(
      content: message,
      isByMe: 1,
      isError: 0,
      timestamp: DateTime.now(),
    );
    Provider.of<ChatProvider>(context, listen: false).addMessage(messageModel);
    Provider.of<ChatProvider>(context, listen: false).setTyping(true);

    final prompt = message;
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);

      final messageModel = Message(
        content: response.text!,
        isByMe: 0,
        isError: 0,
        timestamp: DateTime.now(),
      );
      Provider.of<ChatProvider>(context, listen: false).setTyping(false);
      Provider.of<ChatProvider>(context, listen: false)
          .addMessage(messageModel);
    } catch (e) {
      String errorMessage =
          'An error occurred. Please check your internet connection and try again.';
      if (e.toString().contains('Failed host lookup')) {
        errorMessage =
            'Unable to connect to the AI service. Please check your internet connection and try again.';
      }

      final messageModel = Message(
        content: errorMessage,
        isByMe: 0,
        isError: 1,
        timestamp: DateTime.now(),
      );
      Provider.of<ChatProvider>(context, listen: false).setTyping(false);
      Provider.of<ChatProvider>(context, listen: false)
          .addMessage(messageModel);
    }
  }
}
