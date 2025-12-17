import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'diary.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'mydairy.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  // Insert new entry
  Future<int> insertDiary(Diary diary) async {
    final db = await database;
    return db.insert('diary', diary.toMap());
  }

  // Retrieve all entries 
  Future<List<Diary>> getAllDiaries() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('diary');
    return result.map((e) => Diary.fromMap(e)).toList();
  }

  // Update an entry
  Future<int> updateDiary(Diary diary) async {
    final db = await database;
    return db.update(
      'diary',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  // Delete an entry by ID
  Future<int> deleteDiary(int id) async {
    final db = await database;
    return db.delete('diary', where: 'id = ?', whereArgs: [id]);
  }
}
