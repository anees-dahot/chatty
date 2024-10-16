import 'package:chat_app/helper/datbase_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_app/model/message_model.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isTyping = false;

  List<Message> get messages => _messages;
  bool get isTyping => _isTyping;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> loadMessages() async {
    _messages = await _databaseHelper.getMessages();
    notifyListeners();
  }

  Future<void> addMessage(Message message) async {
    await _databaseHelper.insertMessage(message);
    _messages.add(message);
    notifyListeners();
  }

  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
