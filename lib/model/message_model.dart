class Message {
  final int? id;
  final String content;
  final int isByMe;
  final int isError;
  final DateTime timestamp;

  Message(
      {this.id,
      required this.content,
      required this.isByMe,
      required this.isError,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isByMe': isByMe,
      'isError': isError,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      isByMe: map['isByMe'],
      isError: map['isError'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
