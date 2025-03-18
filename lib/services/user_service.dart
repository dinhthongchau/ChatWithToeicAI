import '../database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  // registerUser
  static Future<int> registerUser(String username, String password) async {
    final db = await DBHelper.database;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  // loginUser
  static Future<int?> loginUser(String username, String password) async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return users.isNotEmpty ? users.first['id'] as int : null;
  }



  //SQLite - ta không cần lưu session, chỉ đơn giản là lưu lại userID 
  //của người dùng khi đăng nhập, sao đó dùng các hàm để lấy dữ liệu của userID đó
  //static Future<void> signOut() async {
  //   final db = await DBHelper.database;
  //   await db.delete('chat_history');  // Xóa toàn bộ lịch sử chat nếu cần
  //   await db.delete('chat_response'); // Xóa tin nhắn chat nếu cần
  // }
}
