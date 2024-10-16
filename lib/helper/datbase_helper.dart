import 'package:chat_app/model/chat_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
  final databaseDirPath = await getDatabasesPath();
  final databasePath = join(databaseDirPath, 'chatty.db');
  return await databaseFactory.openDatabase(
    databasePath,
    options: OpenDatabaseOptions(
      version: 3,  // Increment this
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('DROP TABLE IF EXISTS messages');
          await _createTables(db);
        }
      },
    ),
  );
}

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        isByMe INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
    final data = await db.query('messages');
    print(data);
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    await _createTables(db);
    try {
      final maps = await db.query('messages');
      return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
    } catch (e) {
      // If the table doesn't exist or there's any other error, return an empty list
      print('Error fetching messages: $e');
      return [];
    }
  }
}
