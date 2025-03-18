import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'chat_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE chat_sessions (
            chat_sessions_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE chat_messages (
            chat_messages_id INTEGER PRIMARY KEY AUTOINCREMENT,
            chat_sessions_id INTEGER,
            user_message TEXT,
            ai_response TEXT,
            timestamp TEXT,
            FOREIGN KEY(chat_sessions_id) REFERENCES chat_sessions(chat_sessions_id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
