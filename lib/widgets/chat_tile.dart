import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_shell/model/chat_model.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    bool isMyself = message.senderMyself;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: isMyself ? Colors.transparent : colorScheme.surfaceContainer),
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isMyself ? colorScheme.primary : colorScheme.secondary,
            child: Icon(isMyself ? Icons.person : Icons.auto_awesome, size: 20, color: isMyself ? colorScheme.onPrimary : colorScheme.onSecondary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMyself ? "You" : "AI Assistant",
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontSize: 14),
                ),
                const SizedBox(height: 4),
                SelectableText(message.message, style: TextStyle(color: colorScheme.onSurface, fontSize: 16, height: 1.5)),
                const SizedBox(height: 8),
                Text(DateFormat('hh:mm a').format(message.dateTime), style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
