import 'package:flutter/material.dart';
import 'package:quiz_shell/model/chat_model.dart';
import 'package:quiz_shell/service/api_service.dart';

class ChatProvider with ChangeNotifier {
  ChatMessage welcomeMsg = ChatMessage(message: "Hello! How can I help you today?", dateTime: DateTime.now().subtract(Duration(seconds: 3)), senderMyself: false);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  late List<ChatMessage> messages = [welcomeMsg];

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 400), curve: Curves.easeOut);
      }
      notifyListeners();
    });
  }

  //send Message
  void sendMessage(String msg) {
    controller.clear();
    notifyListeners();
    scrollToBottom();
    messages.add(ChatMessage(message: msg, dateTime: DateTime.now(), senderMyself: true));
    notifyListeners();
    getResponse(msg);
  }

  //get reply
  Future<void> getResponse(String msg) async {
    String? response = await ApiService.getResponseFromAI(msg);
    if (response != null) messages.add(ChatMessage(message: response, dateTime: DateTime.now(), senderMyself: false));
    notifyListeners();
    scrollToBottom();
  }
}
