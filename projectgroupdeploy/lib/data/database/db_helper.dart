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
      version: 2, // Increment the version from 1 to 2
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop old tables and recreate them
          await db.execute('DROP TABLE IF EXISTS chat_messages');
          await db.execute('DROP TABLE IF EXISTS chat_sessions');
          await db.execute('DROP TABLE IF EXISTS users');
          await _createTables(db);
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE chat_sessions (
        chat_sessions_id TEXT PRIMARY KEY,
        user_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE chat_messages (
        chat_messages_id INTEGER PRIMARY KEY AUTOINCREMENT,
        chat_sessions_id TEXT,
        user_message TEXT,
        ai_response TEXT,
        timestamp TEXT,
        FOREIGN KEY(chat_sessions_id) REFERENCES chat_sessions(chat_sessions_id) ON DELETE CASCADE
      )
    ''');
  }
}
