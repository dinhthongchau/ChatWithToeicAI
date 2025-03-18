import '../database/db_helper.dart';


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

}
