import 'package:intl/intl.dart';
import '../models/chat_message_model.dart';
import 'db_helper.dart';

class ChatDB {

  static Future<String> createChatSession(int userId) async {
    final db = await DBHelper.database;

    // Kiểm tra xem có phiên trò chuyện rỗng tồn tại không
    List<Map<String, dynamic>> existingSessions = await db.query(
      'chat_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'chat_sessions_id DESC',
      limit: 1,
    );

    if (existingSessions.isNotEmpty) {
      String existingSessionId = existingSessions.first['chat_sessions_id'] as String;
      // Lấy tất cả tin nhắn của phiên trò chuyện hiện tại
      List<Map<String, dynamic>> messages = await db.query(
        'chat_messages',
        where: 'chat_sessions_id = ?',
        whereArgs: [existingSessionId],
      );
      if (messages.isEmpty) {
        return existingSessionId;
      }
    }
    //format hi
    DateTime now = DateTime.now();
    String newSessionId = DateFormat('HH\'h\'mm\'m\'ss\'s\' dd/MM/yyyy').format(now);
    await db.insert('chat_sessions', {'chat_sessions_id': newSessionId, 'user_id': userId});
    print("Created new session: $newSessionId for user: $userId");
    return newSessionId;
  }



  static Future<List<String>> getUserChatHistory(int userId) async {
    final db = await DBHelper.database;
    // get list
    List<Map<String, dynamic>> result = await db.query(
      'chat_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'chat_sessions_id DESC',
    );
    return result.map((e) => e['chat_sessions_id'] as String).toList();
  }

  // Thêm một đoạn tin nhắn mới vào một phiên trò chuyện
  static Future<int> addChatMessage(String chatSessionsId, String userMessage, String aiResponse) async {
    final db = await DBHelper.database;
    // store message user + reply AI
    return await db.insert('chat_messages', {
      'chat_sessions_id': chatSessionsId,
      'user_message': userMessage,
      'ai_response': aiResponse,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Lấy danh sách tin nhắn của một phiên trò chuyện
  static Future<List<ChatMessageModel>> getChatMessages(
      String chatSessionsId) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'chat_messages',
      where: 'chat_sessions_id = ?',
      whereArgs: [chatSessionsId],
      orderBy: 'timestamp ASC',
    );
    return result.map((e) => ChatMessageModel.fromMap(e)).toList();
  }
  //store message of chat session to DB
  static Future<void> saveChatSession(int userId, String sessionId, List<String> messages) async {
    final db = await DBHelper.database;
    int sessionExists = (await db.query(
      'chat_sessions',
      where: 'chat_sessions_id = ?',
      whereArgs: [sessionId],
    )).isNotEmpty ? 1 : 0;

    if (sessionExists == 0) {
      await db.insert('chat_sessions', {'chat_sessions_id': sessionId, 'user_id': userId});
    }

    // No need to query again if sessionId is already provided
    String? chatSessionsId = sessionId; // Use the provided sessionId directly

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

  // Đổi tên phiên chat vs chat_sessions và chat_messages
  static Future<void> renameChatSession(
      int userId, String oldSessionId, String newSessionId) async {
    final db = await DBHelper.database;
    try {
      // Update chat_sessions table
      await db.update(
        'chat_sessions',
        {'chat_sessions_id': newSessionId},
        where: 'chat_sessions_id = ? AND user_id = ?',
        whereArgs: [oldSessionId, userId],
      );

      // Update chat_messages table (fix the typo)
      await db.update(
        'chat_messages',
        {'chat_sessions_id': newSessionId},
        where: 'chat_sessions_id = ?', // Corrected from 'chat_session_id'
        whereArgs: [oldSessionId],
      );

      print("Renamed chat session in database from '$oldSessionId' to '$newSessionId'");
    } catch (e) {
      print("Error renaming chat session in database: $e");
      rethrow;
    }
  }

  // Xóa phiên chat vs chat_sessions và chat_messages
  static Future<void> deleteChatSession(int userId, String sessionId) async {
    final db = await DBHelper.database;
    var session = await db.query(
      'chat_sessions',
      where: 'user_id = ? AND chat_sessions_id = ?',
      whereArgs: [userId, sessionId],
    );
    if (session.isEmpty) return;

    await db.delete('chat_messages',
        where: 'chat_sessions_id = ?', whereArgs: [sessionId]);
    await db.delete('chat_sessions',
        where: 'chat_sessions_id = ?', whereArgs: [sessionId]);
  }
}
