import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_shell/model/chat_model.dart';
import 'package:quiz_shell/service/api_service.dart';

class ChatProvider with ChangeNotifier {
  ChatMessage welcomeMsg = ChatMessage(
    message: "Hello! How can I help you today?",
    dateTime: DateTime.now().subtract(Duration(seconds: 3)),
    senderMyself: false,
  );
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  late List<ChatMessage> messages = [welcomeMsg];

  static const Duration _typewriterDelay = Duration(milliseconds: 35);

  static final ChatMessage _typingIndicator = ChatMessage(
    message: "",
    dateTime: null,
    senderMyself: false,
    isTyping: true,
  );

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
      notifyListeners();
    });
  }

  //send Message
  void sendMessage(String msg) {
    controller.clear();
    notifyListeners();
    scrollToBottom();
    messages.add(
      ChatMessage(message: msg, dateTime: DateTime.now(), senderMyself: true),
    );
    messages.add(_typingIndicator);
    notifyListeners();
    scrollToBottom();
    getResponse(msg);
  }

  //get reply
  Future<void> getResponse(String msg) async {
    String? response = await ApiService.getResponseFromAI(msg);
    messages.removeWhere((m) => m.isTyping == true);
    if (response == null) {
      notifyListeners();
      return;
    }
    final aiDateTime = DateTime.now();
    final aiMessage = ChatMessage(
      message: "",
      dateTime: aiDateTime,
      senderMyself: false,
    );
    final int messageIdx = messages.length;
    messages.add(aiMessage);
    notifyListeners();
    scrollToBottom();
    _streamTypewriter(messageIdx, aiDateTime, response);
  }

  //word-by-word typewriter effect
  Future<void> _streamTypewriter(
    int messageIdx,
    DateTime dateTime,
    String fullText,
  ) async {
    final List<String> words = fullText.split(' ');
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      if (i > 0) buffer.write(' ');
      buffer.write(words[i]);
      // Bail if the message was removed (e.g., list got reset externally)
      if (messageIdx < 0 || messageIdx >= messages.length) return;
      messages[messageIdx] = ChatMessage(
        message: buffer.toString(),
        dateTime: dateTime,
        senderMyself: false,
      );
      notifyListeners();
      scrollToBottom();
      await Future.delayed(_typewriterDelay);
    }
  }
}
