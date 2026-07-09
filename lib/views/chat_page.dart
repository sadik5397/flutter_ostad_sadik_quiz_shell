import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_shell/l10n/app_localizations.dart';
import 'package:quiz_shell/provider/chat_provider.dart';
import 'package:quiz_shell/widgets/chat_input_field.dart';
import 'package:quiz_shell/widgets/chat_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatWithAi)),
      body: Column(
        children: [
          //thread list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  controller: chatProvider.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) => ChatTile(message: chatProvider.messages[index]),
                );
              },
            ),
          ),
          //textbox
          ChatInputField(),
        ],
      ),
    );
  }
}
