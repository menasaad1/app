import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../utils/date_formatter.dart';
import 'storage_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final StorageService _storageService = StorageService();

  // Create a complete backup of all app data
  Future<String> createFullBackup() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupData = <String, dynamic>{};
    
    try {
      // Get all bishops data
      final bishops = await _storageService.getBishops();
      backupData['bishops'] = bishops;
      
      // Get all dioceses data
      final dioceses = await _storageService.getDioceses();
      backupData['dioceses'] = dioceses;
      
      // Get app settings
      final settings = await _getAppSettings();
      backupData['settings'] = settings;
      
      // Add metadata
      backupData['metadata'] = {
        'version': '1.0.0',
        'created_at': DateTime.now().toIso8601String(),
        'device_info': await _getDeviceInfo(),
        'data_count': {
          'bishops': bishops.length,
          'dioceses': dioceses.length,
        },
      };
      
      // Save backup to file
      final backupJson = jsonEncode(backupData);
      final fileName = 'backup_${DateFormatter.formatDate(DateTime.now()).replaceAll('/', '_')}_$timestamp.json';
      final filePath = await _storageService.createFile(fileName, utf8.encode(backupJson));
      
      return filePath;
    } catch (e) {
      throw Exception('فشل في إنشاء النسخة الاحتياطية: $e');
    }
  }

  // Create a backup of bishops data only
  Future<String> createBishopsBackup() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupData = <String, dynamic>{};
    
    try {
      // Get bishops data
      final bishops = await _storageService.getBishops();
      backupData['bishops'] = bishops;
      
      // Add metadata
      backupData['metadata'] = {
        'type': 'bishops_only',
        'version': '1.0.0',
        'created_at': DateTime.now().toIso8601String(),
        'data_count': bishops.length,
      };
      
      // Save backup to file
      final backupJson = jsonEncode(backupData);
      final fileName = 'bishops_backup_${DateFormatter.formatDate(DateTime.now()).replaceAll('/', '_')}_$timestamp.json';
      final filePath = await _storageService.createFile(fileName, utf8.encode(backupJson));
      
      return filePath;
    } catch (e) {
      throw Exception('فشل في إنشاء نسخة احتياطية للأساقفة: $e');
    }
  }

  // Create a backup of settings only
  Future<String> createSettingsBackup() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupData = <String, dynamic>{};
    
    try {
      // Get settings data
      final settings = await _getAppSettings();
      backupData['settings'] = settings;
      
      // Add metadata
      backupData['metadata'] = {
        'type': 'settings_only',
        'version': '1.0.0',
        'created_at': DateTime.now().toIso8601String(),
      };
      
      // Save backup to file
      final backupJson = jsonEncode(backupData);
      final fileName = 'settings_backup_${DateFormatter.formatDate(DateTime.now()).replaceAll('/', '_')}_$timestamp.json';
      final filePath = await _storageService.createFile(fileName, utf8.encode(backupJson));
      
      return filePath;
    } catch (e) {
      throw Exception('فشل في إنشاء نسخة احتياطية للإعدادات: $e');
    }
  }

  // Restore data from backup file
  Future<void> restoreFromBackup(String backupFilePath) async {
    try {
      final file = File(backupFilePath);
      if (!await file.exists()) {
        throw Exception('ملف النسخة الاحتياطية غير موجود');
      }
      
      final backupJson = await file.readAsString();
      final backupData = jsonDecode(backupJson);
      
      // Validate backup format
      if (!_isValidBackupFormat(backupData)) {
        throw Exception('تنسيق ملف النسخة الاحتياطية غير صحيح');
      }
      
      // Restore bishops data
      if (backupData.containsKey('bishops')) {
        await _restoreBishopsData(backupData['bishops']);
      }
      
      // Restore dioceses data
      if (backupData.containsKey('dioceses')) {
        await _restoreDiocesesData(backupData['dioceses']);
      }
      
      // Restore settings data
      if (backupData.containsKey('settings')) {
        await _restoreSettingsData(backupData['settings']);
      }
      
    } catch (e) {
      throw Exception('فشل في استعادة البيانات من النسخة الاحتياطية: $e');
    }
  }

  // Get list of available backup files
  Future<List<Map<String, dynamic>>> getAvailableBackups() async {
    try {
      final files = await _storageService.listFiles(extension: '.json');
      final backups = <Map<String, dynamic>>[];
      
      for (final filePath in files) {
        if (filePath.contains('backup_')) {
          final file = File(filePath);
          final stat = await file.stat();
          
          backups.add({
            'path': filePath,
            'name': filePath.split('/').last,
            'size': stat.size,
            'created': stat.modified,
            'type': _getBackupType(filePath),
          });
        }
      }
      
      // Sort by creation date (newest first)
      backups.sort((a, b) => (b['created'] as DateTime).compareTo(a['created'] as DateTime));
      
      return backups;
    } catch (e) {
      throw Exception('فشل في الحصول على قائمة النسخ الاحتياطية: $e');
    }
  }

  // Delete a backup file
  Future<void> deleteBackup(String backupFilePath) async {
    try {
      await _storageService.deleteFile(backupFilePath);
    } catch (e) {
      throw Exception('فشل في حذف النسخة الاحتياطية: $e');
    }
  }

  // Get backup file info
  Future<Map<String, dynamic>> getBackupInfo(String backupFilePath) async {
    try {
      final file = File(backupFilePath);
      if (!await file.exists()) {
        throw Exception('ملف النسخة الاحتياطية غير موجود');
      }
      
      final backupJson = await file.readAsString();
      final backupData = jsonDecode(backupJson);
      
      final stat = await file.stat();
      
      return {
        'path': backupFilePath,
        'name': backupFilePath.split('/').last,
        'size': stat.size,
        'created': stat.modified,
        'type': _getBackupType(backupFilePath),
        'data_count': backupData['metadata']?['data_count'] ?? {},
        'version': backupData['metadata']?['version'] ?? '1.0.0',
        'device_info': backupData['metadata']?['device_info'] ?? {},
      };
    } catch (e) {
      throw Exception('فشل في الحصول على معلومات النسخة الاحتياطية: $e');
    }
  }

  // Export backup to external storage
  Future<String> exportBackup(String backupFilePath) async {
    try {
      final file = File(backupFilePath);
      if (!await file.exists()) {
        throw Exception('ملف النسخة الاحتياطية غير موجود');
      }
      
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('لا يمكن الوصول إلى التخزين الخارجي');
      }
      
      final fileName = backupFilePath.split('/').last;
      final exportPath = '${directory.path}/$fileName';
      final exportFile = File(exportPath);
      
      await file.copy(exportFile.path);
      
      return exportPath;
    } catch (e) {
      throw Exception('فشل في تصدير النسخة الاحتياطية: $e');
    }
  }

  // Import backup from external storage
  Future<String> importBackup(String importFilePath) async {
    try {
      final file = File(importFilePath);
      if (!await file.exists()) {
        throw Exception('ملف النسخة الاحتياطية غير موجود');
      }
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = importFilePath.split('/').last;
      final importPath = '${directory.path}/$fileName';
      final importFile = File(importPath);
      
      await file.copy(importFile.path);
      
      return importPath;
    } catch (e) {
      throw Exception('فشل في استيراد النسخة الاحتياطية: $e');
    }
  }

  // Private helper methods
  Future<Map<String, dynamic>> _getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final settings = <String, dynamic>{};
    
    for (final key in keys) {
      final value = prefs.get(key);
      settings[key] = value;
    }
    
    return settings;
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
    };
  }

  bool _isValidBackupFormat(Map<String, dynamic> data) {
    return data.containsKey('metadata') && 
           data['metadata'] is Map<String, dynamic> &&
           data['metadata'].containsKey('version');
  }

  String _getBackupType(String filePath) {
    if (filePath.contains('bishops_backup_')) {
      return 'bishops_only';
    } else if (filePath.contains('settings_backup_')) {
      return 'settings_only';
    } else {
      return 'full_backup';
    }
  }

  Future<void> _restoreBishopsData(List<dynamic> bishopsData) async {
    // Clear existing bishops data
    await _storageService.clearDatabase();
    
    // Insert restored bishops data
    for (final bishopData in bishopsData) {
      await _storageService.insertBishop(bishopData as Map<String, dynamic>);
    }
  }

  Future<void> _restoreDiocesesData(List<dynamic> diocesesData) async {
    // Insert restored dioceses data
    for (final dioceseData in diocesesData) {
      await _storageService.insertDiocese(dioceseData as Map<String, dynamic>);
    }
  }

  Future<void> _restoreSettingsData(Map<String, dynamic> settingsData) async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in settingsData.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      }
    }
  }
}