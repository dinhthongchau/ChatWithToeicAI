// lưu trữ dữ liệu

// import 'package:sqflite/sqflite.dart';
import '../models/chat_message_model.dart';
import 'db_helper.dart';

class ChatDB {
  // Tạo một phiên trò chuyện mới cho một user
  static Future<int?> createChatSession(int userId) async {
    final db = await DBHelper.database;

    // Kiểm tra nếu có session chưa có tin nhắn thì không tạo mới
    List<Map<String, dynamic>> existingSessions = await db.query(
      'chat_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'chat_sessions_id DESC',
      limit: 1,
    );

    if (existingSessions.isNotEmpty) {
      int existingSessionId = existingSessions.first['chat_sessions_id'];
      List<Map<String, dynamic>> messages = await db.query(
        'chat_messages',
        where: 'chat_sessions_id = ?',
        whereArgs: [existingSessionId],
      );

      // Nếu session chưa có tin nhắn thì trả về session cũ, không tạo mới
      if (messages.isEmpty) {
        return existingSessionId;
      }
    }

    // Nếu không có session hợp lệ, tạo mới
    return await db.insert('chat_sessions', {'user_id': userId});
  }


  // Lấy danh sách các phiên trò chuyện của một user
  static Future<List<String>> getUserChatHistory(int userId) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'chat_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'chat_sessions_id DESC',
    );
    print("Chat history result from DB: $result"); // Debug log

    return result.map((e) => e['chat_sessions_id'].toString()).toSet().toList();
  }

  // Thêm một đoạn tin nhắn mới vào một phiên trò chuyện
  static Future<int> addChatMessage(
      int chatSessionsId, String userMessage, String aiResponse) async {
    final db = await DBHelper.database;
    return await db.insert('chat_messages', {
      'chat_sessions_id': chatSessionsId,
      'user_message': userMessage,
      'ai_response': aiResponse,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Lấy danh sách tin nhắn của một phiên trò chuyện
  static Future<List<ChatMessageModel>> getChatMessages(
      int chatSessionsId) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'chat_messages',
      where: 'chat_sessions_id = ?',
      whereArgs: [chatSessionsId],
      orderBy: 'timestamp ASC',
    );
    return result.map((e) => ChatMessageModel.fromMap(e)).toList();
  }

  // Lưu phiên chat
  static Future<void> saveChatSession(
      int userId, String sessionId, List<String> messages) async {
    final db = await DBHelper.database;
    int sessionExists = (await db.query(
      'chat_sessions',
      where: 'chat_sessions_id = ?',
      whereArgs: [sessionId],
    ))
            .isNotEmpty
        ? 1
        : 0;

    if (sessionExists == 0) {
      await db.insert('chat_sessions', {'user_id': userId});
    }

    List<Map<String, dynamic>> result = await db.query(
      'chat_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'chat_sessions_id DESC',
      limit: 1,
    );

    int? chatSessionsId =
        result.isNotEmpty ? result.first['chat_sessions_id'] as int? : null;

    for (int i = 0; i < messages.length; i += 2) {
      await db.insert('chat_messages', {
        'chat_sessions_id': chatSessionsId,
        'user_message': messages[i],
        'ai_response': (i + 1 < messages.length) ? messages[i + 1] : '',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  // Tải tin nhắn của một phiên chat
  static Future<List<String>> loadChatMessages(
      int userId, String sessionId) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'chat_messages',
      where: 'chat_sessions_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );
    List<String> messages = [];
    for (var msg in result) {
      messages.add(msg['user_message']);
      messages.add(msg['ai_response']);
    }
    return messages;
  }

  // Đổi tên phiên chat
  static Future<void> renameChatSession(
      int userId, String oldSessionId, String newSessionId) async {
    final db = await DBHelper.database;
    await db.update(
      'chat_sessions',
      {'chat_sessions_id': newSessionId},
      where: 'chat_sessions_id = ? AND user_id = ?',
      whereArgs: [oldSessionId, userId],
    );
  }

  // Xóa phiên chat
  static Future<void> deleteChatSession(int userId, String sessionId) async {
    final db = await DBHelper.database;
    var session = await db.query(
      'chat_sessions',
      where: 'user_id = ? AND chat_sessions_id = ?',
      whereArgs: [userId, sessionId],
    );
    if (session.isEmpty) return;
    int chatSessionsId = session.first['chat_sessions_id'] as int;

    await db.delete('chat_messages',
        where: 'chat_sessions_id = ?', whereArgs: [chatSessionsId]);
    await db.delete('chat_sessions',
        where: 'chat_sessions_id = ?', whereArgs: [chatSessionsId]);
  }
}
