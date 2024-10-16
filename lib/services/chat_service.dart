import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: 'AIzaSyCu7yeA3GYn19Q3gDxw1IGVEwuj-0OgunY',
  );
  void sendMessage(String message) async {
    print('model run');

    Map<String, dynamic> myMessage = {
      'content': message,
      'isMe': 'true',
      'timestamp': DateTime.now().toString(),
    };
    // messages.add(myMessage);

    final prompt = message;
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
      // messages.add(aiResponse);
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
      // messages.add(errorResponse);
    }
  }
}
