class ChatSessionModel {
  int? id;
  int userId;

  ChatSessionModel({this.id, required this.userId});

  // Chuyển đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
    };
  }

  // Chuyển từ Map thành đối tượng ChatHistory
  factory ChatSessionModel.fromMap(Map<String, dynamic> map) {
    return ChatSessionModel(
      id: map['id'],
      userId: map['user_id'],
    );
  }
}
