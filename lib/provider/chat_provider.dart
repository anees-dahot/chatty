import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  bool _isTyping = false;

  bool get isTyping => _isTyping;

  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
