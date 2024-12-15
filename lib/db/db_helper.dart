import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db_models/db_user.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB();
      return _db!;
    }
  }

  static Future<Database> initDB() async {
    var appDir = await getApplicationCacheDirectory();
    String dbPath = join(appDir.path, 'database.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE db_user(
            login TEXT PRIMARY KEY,
            token TEXT,
            avatarUrl TEXT,
            rememberPwd INTEGER)''');
      }
    );
  }

  static Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }

  static Future<int> insertUser(DbUser user) async {
    final db = await database;
    return await db.insert(
        'db_user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<List<DbUser>> getUsers() async {
    final db = await database;
    var result = await db.query('db_user');
    return result.map((e) => DbUser.fromMap(e)).toList();
  }

  static Future<int> updateUser(DbUser user) async {
    final db = await database;
    return await db.update(
      'db_user',
      user.toMap(),
      where: 'login = ?',
      whereArgs: [user.login]
    );
  }

  static Future<int> deleteUser(DbUser user) async {
    final db = await database;
    return await db.delete(
      'db_user',
      where: 'login = ?',
      whereArgs: [user.login]
    );
  }

  static Future<int> deleteAllUser() async {
    final db = await database;
    return await db.delete('db_user');
  }
}