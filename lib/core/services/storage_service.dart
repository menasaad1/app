import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Database _database;
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);
    
    _database = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create bishops table
    await db.execute('''
      CREATE TABLE bishops (
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

    // Create dioceses table
    await db.execute('''
      CREATE TABLE dioceses (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        region TEXT,
        country TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // Create settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // SharedPreferences methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  // Database methods
  Future<void> insertBishop(Map<String, dynamic> bishop) async {
    await _database.insert('bishops', bishop);
  }

  Future<List<Map<String, dynamic>>> getBishops() async {
    return await _database.query('bishops', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getBishop(String id) async {
    final results = await _database.query(
      'bishops',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateBishop(String id, Map<String, dynamic> bishop) async {
    await _database.update(
      'bishops',
      bishop,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBishop(String id) async {
    await _database.delete(
      'bishops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> searchBishops(String query) async {
    return await _database.query(
      'bishops',
      where: 'name LIKE ? OR title LIKE ? OR diocese LIKE ? OR biography LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
  }

  Future<List<String>> getDioceses() async {
    final results = await _database.query('dioceses', orderBy: 'name ASC');
    return results.map((row) => row['name'] as String).toList();
  }

  Future<void> insertDiocese(Map<String, dynamic> diocese) async {
    await _database.insert('dioceses', diocese);
  }

  Future<void> updateDiocese(String id, Map<String, dynamic> diocese) async {
    await _database.update(
      'dioceses',
      diocese,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDiocese(String id) async {
    await _database.delete(
      'dioceses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setSetting(String key, String value) async {
    await _database.insert(
      'settings',
      {
        'key': key,
        'value': value,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  String? getSetting(String key) {
    // Note: This is a synchronous method, but database operations are async
    // In a real implementation, you might want to cache settings in memory
    return null;
  }

  Future<String?> getSettingAsync(String key) async {
    final results = await _database.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    return results.isNotEmpty ? results.first['value'] as String : null;
  }

  // File operations
  Future<String> getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getCacheDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> createFile(String fileName, List<int> data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(data);
    return file.path;
  }

  Future<File> getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<bool> fileExists(String fileName) async {
    final file = await getFile(fileName);
    return await file.exists();
  }

  Future<void> deleteFile(String fileName) async {
    final file = await getFile(fileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<String>> listFiles({String? extension}) async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync()
        .where((file) => file is File)
        .map((file) => file.path)
        .toList();
    
    if (extension != null) {
      return files.where((path) => path.endsWith(extension)).toList();
    }
    
    return files;
  }

  Future<int> getFileSize(String fileName) async {
    final file = await getFile(fileName);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  Future<DateTime> getFileModifiedDate(String fileName) async {
    final file = await getFile(fileName);
    if (await file.exists()) {
      return await file.lastModified();
    }
    return DateTime.now();
  }

  // Cache management
  Future<void> clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  Future<int> getCacheSize() async {
    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    }
    return 0;
  }

  // Database management
  Future<void> clearDatabase() async {
    await _database.delete('bishops');
    await _database.delete('dioceses');
    await _database.delete('settings');
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }

  // Backup and restore
  Future<String> createBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File('${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.db');
    
    // Copy database file
    final dbFile = File(join(directory.path, AppConstants.databaseName));
    if (await dbFile.exists()) {
      await dbFile.copy(backupFile.path);
    }
    
    return backupFile.path;
  }

  Future<void> restoreBackup(String backupPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final dbFile = File(join(directory.path, AppConstants.databaseName));
    final backupFile = File(backupPath);
    
    if (await backupFile.exists()) {
      await backupFile.copy(dbFile.path);
      // Reinitialize database
      await _initializeDatabase();
    }
  }
}

