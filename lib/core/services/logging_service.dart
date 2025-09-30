import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  final List<LogEntry> _logs = [];
  final int _maxLogs = 1000;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isInitialized = true;
    await _loadLogsFromFile();
  }

  // Log levels
  void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  void info(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  void warning(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  void error(String message, {String? tag, Map<String, dynamic>? data, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, data: data, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, {String? tag, Map<String, dynamic>? data, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, tag: tag, data: data, error: error, stackTrace: stackTrace);
  }

  // Private log method
  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      level: level,
      message: message,
      tag: tag,
      data: data,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _logs.add(entry);

    // Keep only the last _maxLogs entries
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }

    // Print to console in debug mode
    if (Platform.isAndroid || Platform.isIOS) {
      _printToConsole(entry);
    }

    // Save to file
    _saveLogsToFile();
  }

  // Print log entry to console
  void _printToConsole(LogEntry entry) {
    final levelColor = _getLevelColor(entry.level);
    final timestamp = DateFormat('HH:mm:ss.SSS').format(entry.timestamp);
    final tag = entry.tag != null ? '[${entry.tag}]' : '';
    final message = entry.message;
    
    print('$levelColor$timestamp$tag $message');
    
    if (entry.error != null) {
      print('Error: ${entry.error}');
    }
    
    if (entry.stackTrace != null) {
      print('Stack trace: ${entry.stackTrace}');
    }
  }

  // Get color for log level
  String _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1B[37m'; // White
      case LogLevel.info:
        return '\x1B[34m'; // Blue
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.fatal:
        return '\x1B[35m'; // Magenta
    }
  }

  // Get all logs
  List<LogEntry> getAllLogs() {
    return List.unmodifiable(_logs);
  }

  // Get logs by level
  List<LogEntry> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  // Get logs by tag
  List<LogEntry> getLogsByTag(String tag) {
    return _logs.where((log) => log.tag == tag).toList();
  }

  // Get logs within time range
  List<LogEntry> getLogsInRange(DateTime start, DateTime end) {
    return _logs.where((log) => 
      log.timestamp.isAfter(start) && log.timestamp.isBefore(end)
    ).toList();
  }

  // Get recent logs
  List<LogEntry> getRecentLogs(int count) {
    final startIndex = _logs.length - count;
    return _logs.skip(startIndex < 0 ? 0 : startIndex).toList();
  }

  // Clear all logs
  void clearLogs() {
    _logs.clear();
    _saveLogsToFile();
  }

  // Clear logs by level
  void clearLogsByLevel(LogLevel level) {
    _logs.removeWhere((log) => log.level == level);
    _saveLogsToFile();
  }

  // Clear logs by tag
  void clearLogsByTag(String tag) {
    _logs.removeWhere((log) => log.tag == tag);
    _saveLogsToFile();
  }

  // Clear old logs
  void clearOldLogs(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    _logs.removeWhere((log) => log.timestamp.isBefore(cutoff));
    _saveLogsToFile();
  }

  // Search logs
  List<LogEntry> searchLogs(String query) {
    return _logs.where((log) => 
      log.message.toLowerCase().contains(query.toLowerCase()) ||
      (log.tag?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Save logs to file
  Future<void> _saveLogsToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.txt');
      
      final logLines = _logs.map((log) => _formatLogEntry(log)).join('\n');
      await file.writeAsString(logLines);
    } catch (e) {
      // Don't log this error to avoid infinite recursion
      print('Failed to save logs to file: $e');
    }
  }

  // Load logs from file
  Future<void> _loadLogsFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.txt');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final lines = content.split('\n').where((line) => line.isNotEmpty);
        
        for (final line in lines) {
          final entry = _parseLogEntry(line);
          if (entry != null) {
            _logs.add(entry);
          }
        }
      }
    } catch (e) {
      // Don't log this error to avoid infinite recursion
      print('Failed to load logs from file: $e');
    }
  }

  // Format log entry for file storage
  String _formatLogEntry(LogEntry entry) {
    final timestamp = entry.timestamp.toIso8601String();
    final level = entry.level.name.toUpperCase();
    final tag = entry.tag ?? '';
    final message = entry.message;
    final data = entry.data != null ? ' | Data: ${entry.data}' : '';
    final error = entry.error != null ? ' | Error: ${entry.error}' : '';
    final stackTrace = entry.stackTrace != null ? ' | Stack: ${entry.stackTrace}' : '';
    
    return '$timestamp | $level | $tag | $message$data$error$stackTrace';
  }

  // Parse log entry from file
  LogEntry? _parseLogEntry(String line) {
    try {
      final parts = line.split(' | ');
      if (parts.length < 4) return null;
      
      final timestamp = DateTime.parse(parts[0]);
      final level = LogLevel.values.firstWhere(
        (l) => l.name.toUpperCase() == parts[1],
        orElse: () => LogLevel.info,
      );
      final tag = parts[2].isEmpty ? null : parts[2];
      final message = parts[3];
      
      return LogEntry(
        level: level,
        message: message,
        tag: tag,
        timestamp: timestamp,
      );
    } catch (e) {
      return null;
    }
  }

  // Export logs to file
  Future<String> exportLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/logs_export_$timestamp.txt');
      
      final logLines = _logs.map((log) => _formatLogEntry(log)).join('\n');
      await file.writeAsString(logLines);
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to export logs: $e');
    }
  }

  // Get log statistics
  Map<String, dynamic> getLogStatistics() {
    final stats = <String, dynamic>{};
    
    for (final level in LogLevel.values) {
      stats[level.name] = _logs.where((log) => log.level == level).length;
    }
    
    stats['total'] = _logs.length;
    stats['oldest'] = _logs.isNotEmpty ? _logs.first.timestamp : null;
    stats['newest'] = _logs.isNotEmpty ? _logs.last.timestamp : null;
    
    return stats;
  }

  // Search logs
  List<LogEntry> searchLogs(String query) {
    return _logs.where((log) => 
      log.message.toLowerCase().contains(query.toLowerCase()) ||
      (log.tag?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Get logs for specific time period
  List<LogEntry> getLogsForToday() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getLogsInRange(startOfDay, endOfDay);
  }

  // Get logs for specific time period
  List<LogEntry> getLogsForThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return getLogsInRange(startOfWeek, endOfWeek);
  }

  // Get logs for specific time period
  List<LogEntry> getLogsForThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    
    return getLogsInRange(startOfMonth, endOfMonth);
  }
}

class LogEntry {
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? data;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.data,
    this.error,
    this.stackTrace,
    required this.timestamp,
  });
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}