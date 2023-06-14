import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'game.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS games (
        id INTEGER PRIMARY KEY,
        player1 TEXT,
        player2 TEXT,
        winner TEXT
      )
    ''');
  }

  Future<int> insertGame(String player1, String player2, String winner) async {
    final db = await database;
    final id = await db.insert(
      'games',
      {
        'player1': player1,
        'player2': player2,
        'winner': winner,
      },
    );
    return id;
  }

  Future<int> deleteGame(int id) async {
    final db = await database;
    return await db.delete(
      'games',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllGames() async {
    final db = await database;
    return await db.delete('games');
  }

  Future<List<Map<String, dynamic>>> getGames() async {
    final db = await database;
    return await db.query('games');
  }
}
