import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._();

  DatabaseService._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI

    // Get the database path
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "chatty.db");

    // Open the database
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE chat (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              message TEXT NOT NULL
            )
          ''');
        },
      ),
    );
  }

  Future<void> addMessage(String name, String message) async {
    final db = await database;
    await db.insert('chat', {
      'name': name,
      'message': message,
    });
    final data = await db.query('chat');
    print(data);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('chat');
  }
}
