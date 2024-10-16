import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isError
                    ? [Colors.red[900]!, Colors.red[700]!]
                    : (isMe
                        ? [Colors.blue[700]!, Colors.blue[500]!]
                        : [Colors.grey[800]!, Colors.grey[700]!]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildMessageContent(),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    final parts = message.split(RegExp(r'```'));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(parts.length, (index) {
        if (index.isEven) {
          return _buildTextWithBoldParts(parts[index]);
        } else {
          return CodeBlock(
            code: parts[index],
            isMe: isMe,
          );
        }
      }),
    );
  }

  Widget _buildTextWithBoldParts(String text) {
    final boldPattern = RegExp(r'\*\*(.*?)\*\*');
    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            color: isError ? Colors.white : Colors.white,
            fontSize: 15,
          ),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          color: isError ? Colors.white : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: isError ? Colors.white : Colors.white,
          fontSize: 15,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  final bool isMe;

  const CodeBlock({
    Key? key,
    required this.code,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[900] : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Code',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.grey[300],
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code.trim(),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontFamily: 'Roboto Mono',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
