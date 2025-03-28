import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import 'db_helper.dart';

class UserDB {

  // insertUser: đăng kí tài khoản người dùng
  static Future<int> signupUser(User user) async {
    final db = await DBHelper.database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  // loginUser: Kiểm tra đăng nhập
  static Future<User?> loginUser(String username, String password) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
  // get User ID
  static Future<int?> getUserIdByEmail(String email) async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['user_id'],
      where: 'username = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['user_id'] as int;
    }
    return null;
  }
}
