class ChatMessageModel {
  int? id;
  String  chatId;
  String userMessage;
  String aiResponse;
  String timestamp;

  ChatMessageModel({
    this.id,
    required this.chatId,
    required this.userMessage,
    required this.aiResponse,
    required this.timestamp, //đầu tiên lưu thời gian tạo chat, sau đó user có thể đổi lại thành tên chat phù hợp
  });

  // Chuyển đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_message': userMessage,
      'ai_response': aiResponse,
      'timestamp': timestamp,
    };
  }

  // Chuyển từ Map thành đối tượng ChatMessageModel
  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'],
      chatId: map['chat_id'],
      userMessage: map['user_message'],
      aiResponse: map['ai_response'],
      timestamp: map['timestamp'],
    );
  }
}
