import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  runApp(const MyApp());
  print('srart');
  // final model = GenerativeModel(
  //   model: 'gemini-1.5-flash-latest',
  //   apiKey: 'AIzaSyCu7yeA3GYn19Q3gDxw1IGVEwuj-0OgunY',
  // );
  // print('model run');

  // final prompt = 'create me  a chating app in flutter';
  // final content = [Content.text(prompt)];
  // print(content);
  // final response = await model.generateContent(content);
  // print(response.promptFeedback);
  // print(response.candidates);

  // print(response.text);
  // print(response.text);
  final DatabaseService databaseService = DatabaseService.instance;
  databaseService.addMessage('sasas', 'fosasasod');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Chatty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  ChatScreen(),
    );
  }
}
