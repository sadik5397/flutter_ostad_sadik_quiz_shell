import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:intl/intl.dart';
import 'package:quiz_shell/model/chat_model.dart';
import 'package:quiz_shell/widgets/typing_indicator.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isMyself = message.senderMyself;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color bubbleColor = isMyself ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final Color textColor = isMyself ? colorScheme.onPrimary : colorScheme.onSurface;
    final Color timeColor = isMyself ? colorScheme.onPrimary.withValues(alpha: 0.75) : colorScheme.onSurfaceVariant;
    final BorderRadius radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMyself ? 18 : 4),
      bottomRight: Radius.circular(isMyself ? 4 : 18),
    );

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
      child: message.isTyping
          ? TypingIndicator(dotColor: textColor)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isMyself
                    ? SelectableText(message.message, style: TextStyle(color: textColor, fontSize: 15, height: 1.35))
                    : MarkdownBody(
                        data: message.message,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(color: textColor, fontSize: 15, height: 1.35),
                          a: TextStyle(color: textColor, decoration: TextDecoration.underline),
                          code: TextStyle(color: textColor, fontFamily: 'monospace', fontSize: 13),
                        ),
                      ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(message.dateTime == null ? "" : DateFormat('hh:mm a').format(message.dateTime!), style: TextStyle(color: timeColor, fontSize: 10)),
                ),
              ],
            ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isMyself ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyself) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondary,
              child: Icon(Icons.auto_awesome, size: 18, color: colorScheme.onSecondary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(child: bubble),
          if (isMyself) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.person, size: 18, color: colorScheme.onPrimary),
            ),
          ],
        ],
      ),
    );
  }
}
