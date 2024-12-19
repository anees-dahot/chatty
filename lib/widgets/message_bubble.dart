import 'package:chat_app/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime time;
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe) _buildAvatar(),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe 
                      ? Colors.grey[100] // Light blue for user messages
                      : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildMessageContent(),
                ),
              ),
              // const SizedBox(width: 8),
              // isMe ? const SizedBox() : _buildAvatar(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 36,
              right: isMe ? 36 : 0,
              top: 4,
            ),
            child: Text(
              formatTimestamp(time),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 14,
      backgroundColor:  Colors.teal,
      child: Icon(
        Icons.android,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageContent() {
    final parts = message.split(RegExp(r'```'));
    
    return SelectableText.rich(
      TextSpan(
        children: List.generate(parts.length, (index) {
          if (index.isEven) {
            return _buildTextWithBoldParts(parts[index]);
          } else {
            // Display the code block
            return WidgetSpan(
              child: CodeBlock(
                code: parts[index].trim(),
                isMe: isMe,
              ),
            );
          }
        }),
      ),
    );
  }

  TextSpan _buildTextWithBoldParts(String text) {
    final boldPattern = RegExp(r'\*\*(.*?)\*\*');
    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ));
    }

    return TextSpan(
      children: spans,
      style: TextStyle(
        color: Colors.grey[800], // Dark gray text for better readability
        fontSize: 16,
      ),
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
        color: Colors.grey, // Very light gray background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black), // Subtle border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black, // Light gray code background
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
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
