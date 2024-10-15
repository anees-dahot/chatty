import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  String message;
  int isSentByMe;
  String time;
  ChatModel({
    required this.message,
    required this.isSentByMe,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'isSentByMe': isSentByMe,
      'time': time,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'] as String,
      isSentByMe: map['isSentByMe'] as int,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatModel(message: $message, isSentByMe: $isSentByMe, time: $time)';

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.isSentByMe == isSentByMe &&
        other.time == time;
  }

  @override
  int get hashCode => message.hashCode ^ isSentByMe.hashCode ^ time.hashCode;
}
