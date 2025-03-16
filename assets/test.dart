import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void checkDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, "D:\Hao\HaoProject\ct312hm01-project-dinhthongchau\assets\chat_app.db");

  Database db = await openDatabase(path);
  List<Map> tables =
      await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
  print("Tables: $tables");

  // List<Map> data = await db.rawQuery("SELECT * FROM your_table_name");
  // print("Data: $data");

  db.close();
}
