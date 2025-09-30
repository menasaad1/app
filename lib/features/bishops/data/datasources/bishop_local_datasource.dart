import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entities/bishop.dart';
import '../../domain/entities/bishop_filter.dart';

abstract class BishopLocalDataSource {
  Future<List<Bishop>> getBishops({BishopFilter? filter});
  Future<Bishop?> getBishopById(String id);
  Future<void> addBishop(Bishop bishop);
  Future<void> updateBishop(Bishop bishop);
  Future<void> deleteBishop(String id);
  Future<List<String>> getDioceses();
  Future<List<Bishop>> searchBishops(String query);
  Future<Map<String, int>> getBishopStatistics();
}

class BishopLocalDataSourceImpl implements BishopLocalDataSource {
  static Database? _database;
  static const String _tableName = 'bishops';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bishops.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        title TEXT NOT NULL,
        diocese TEXT NOT NULL,
        ordinationDate INTEGER NOT NULL,
        birthDate INTEGER NOT NULL,
        phoneNumber TEXT,
        email TEXT,
        address TEXT,
        biography TEXT,
        photoUrl TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        createdBy TEXT NOT NULL,
        updatedBy TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<List<Bishop>> getBishops({BishopFilter? filter}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    
    List<Bishop> bishops = maps.map((map) => Bishop.fromMap(map)).toList();
    
    if (filter != null) {
      bishops = filter.applySearchFilter(bishops);
    }
    
    return bishops;
  }

  @override
  Future<Bishop?> getBishopById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Bishop.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> addBishop(Bishop bishop) async {
    final db = await database;
    await db.insert(_tableName, bishop.toMap());
  }

  @override
  Future<void> updateBishop(Bishop bishop) async {
    final db = await database;
    await db.update(
      _tableName,
      bishop.toMap(),
      where: 'id = ?',
      whereArgs: [bishop.id],
    );
  }

  @override
  Future<void> deleteBishop(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<String>> getDioceses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT diocese FROM $_tableName ORDER BY diocese',
    );
    
    return maps.map((map) => map['diocese'] as String).toList();
  }

  @override
  Future<List<Bishop>> searchBishops(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'name LIKE ? OR title LIKE ? OR diocese LIKE ? OR biography LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    
    return maps.map((map) => Bishop.fromMap(map)).toList();
  }

  @override
  Future<Map<String, int>> getBishopStatistics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT diocese, COUNT(*) as count FROM $_tableName GROUP BY diocese',
    );
    
    final statistics = <String, int>{};
    for (final map in maps) {
      statistics[map['diocese'] as String] = map['count'] as int;
    }
    
    return statistics;
  }
}
