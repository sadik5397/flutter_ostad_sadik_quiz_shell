class ChatMessage {
  final String message;
  final DateTime? dateTime;
  final bool senderMyself;
  final bool isTyping;

  ChatMessage({
    required this.message,
    required this.dateTime,
    required this.senderMyself,
    this.isTyping = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? 0,
      dateTime: json['dateTime'] ?? '',
      senderMyself: json['senderMyself'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'dateTime': dateTime,
      'senderMyself': senderMyself,
    };
  }
}
