import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_shell/model/chat_model.dart';
import 'package:quiz_shell/service/api_service.dart';

class ChatProvider with ChangeNotifier {
  ChatMessage welcomeMsg = ChatMessage(message: "Hello! How can I help you today?", dateTime: DateTime.now().subtract(Duration(seconds: 3)), senderMyself: false);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  late List<ChatMessage> messages = [welcomeMsg];

  static const Duration _typewriterDelay = Duration(milliseconds: 50);

  static final ChatMessage _typingIndicator = ChatMessage(message: "", dateTime: null, senderMyself: false, isTyping: true);

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  //send Message
  void sendMessage(String msg) {
    controller.clear();
    notifyListeners();
    scrollToBottom();
    messages.add(ChatMessage(message: msg, dateTime: DateTime.now(), senderMyself: true));
    messages.add(_typingIndicator);
    notifyListeners();
    scrollToBottom();
    getResponse(msg);
  }

  //get reply
  Future<void> getResponse(String msg) async {
    try {
      String? response = await ApiService.getResponseFromAI(msg);
      messages.removeWhere((m) => m.isTyping == true);

      if (response == null || response.isEmpty) {
        notifyListeners();
        return;
      }

      final aiDateTime = DateTime.now();
      ChatMessage aiMessage = ChatMessage(message: "", dateTime: aiDateTime, senderMyself: false);
      messages.add(aiMessage);
      notifyListeners();
      scrollToBottom();

      await _streamTypewriter(aiMessage, aiDateTime, response);
    } catch (e) {
      messages.removeWhere((m) => m.isTyping == true);
      messages.add(ChatMessage(message: "Sorry, I encountered an error. Please try again.", dateTime: DateTime.now(), senderMyself: false));
      notifyListeners();
      scrollToBottom();
    }
  }

  // Word-by-word typewriter effect for a smoother experience
  Future<void> _streamTypewriter(ChatMessage aiMessageObj, DateTime dateTime, String fullText) async {
    ChatMessage currentAiMessage = aiMessageObj;
    List<String> words = fullText.split(' ');
    String displayedText = "";

    for (int i = 0; i < words.length; i++) {
      displayedText += (i == 0 ? "" : " ") + words[i];

      // Find the current index of our message object (it might have shifted)
      int idx = messages.indexOf(currentAiMessage);
      if (idx == -1) return; // Message was removed from list

      currentAiMessage = ChatMessage(message: displayedText, dateTime: dateTime, senderMyself: false);

      messages[idx] = currentAiMessage;
      notifyListeners();

      // Scroll to maintain focus on new text
      scrollToBottom();

      // Small delay between words
      await Future.delayed(_typewriterDelay);
    }
  }
}
