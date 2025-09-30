import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  final List<ErrorInfo> _errors = [];
  final int _maxErrors = 100;
  final StreamController<ErrorInfo> _errorController = StreamController<ErrorInfo>.broadcast();

  // Getters
  List<ErrorInfo> get errors => List.unmodifiable(_errors);
  Stream<ErrorInfo> get errorStream => _errorController.stream;

  // Initialize error service
  Future<void> initialize() async {
    // Set up global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };
  }

  // Handle Flutter errors
  void _handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      type: ErrorType.flutter,
      message: details.exception.toString(),
      stackTrace: details.stack,
      context: details.context?.toString(),
      library: details.library,
      timestamp: DateTime.now(),
    );

    _addError(errorInfo);
  }

  // Handle platform errors
  void _handlePlatformError(Object error, StackTrace stack) {
    final errorInfo = ErrorInfo(
      type: ErrorType.platform,
      message: error.toString(),
      stackTrace: stack,
      timestamp: DateTime.now(),
    );

    _addError(errorInfo);
  }

  // Add error to the list
  void _addError(ErrorInfo errorInfo) {
    _errors.add(errorInfo);

    // Keep only the last _maxErrors entries
    if (_errors.length > _maxErrors) {
      _errors.removeAt(0);
    }

    // Emit error to stream
    _errorController.add(errorInfo);

    // Log error in debug mode
    if (kDebugMode) {
      print('Error: ${errorInfo.message}');
      if (errorInfo.stackTrace != null) {
        print('Stack trace: ${errorInfo.stackTrace}');
      }
    }
  }

  // Report custom error
  void reportError(
    String message, {
    ErrorType type = ErrorType.custom,
    Object? error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? data,
  }) {
    final errorInfo = ErrorInfo(
      type: type,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
      data: data,
      timestamp: DateTime.now(),
    );

    _addError(errorInfo);
  }

  // Report network error
  void reportNetworkError(
    String message, {
    String? endpoint,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.network,
      error: error,
      stackTrace: stackTrace,
      data: {
        'endpoint': endpoint,
        'status_code': statusCode,
      },
    );
  }

  // Report database error
  void reportDatabaseError(
    String message, {
    String? operation,
    String? table,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.database,
      error: error,
      stackTrace: stackTrace,
      data: {
        'operation': operation,
        'table': table,
      },
    );
  }

  // Report file error
  void reportFileError(
    String message, {
    String? operation,
    String? filePath,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.file,
      error: error,
      stackTrace: stackTrace,
      data: {
        'operation': operation,
        'file_path': filePath,
      },
    );
  }

  // Report validation error
  void reportValidationError(
    String message, {
    String? field,
    String? value,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.validation,
      error: error,
      stackTrace: stackTrace,
      data: {
        'field': field,
        'value': value,
      },
    );
  }

  // Report permission error
  void reportPermissionError(
    String message, {
    String? permission,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.permission,
      error: error,
      stackTrace: stackTrace,
      data: {
        'permission': permission,
      },
    );
  }

  // Report authentication error
  void reportAuthError(
    String message, {
    String? method,
    Object? error,
    StackTrace? stackTrace,
  }) {
    reportError(
      message,
      type: ErrorType.authentication,
      error: error,
      stackTrace: stackTrace,
      data: {
        'method': method,
      },
    );
  }

  // Get errors by type
  List<ErrorInfo> getErrorsByType(ErrorType type) {
    return _errors.where((error) => error.type == type).toList();
  }

  // Get errors by context
  List<ErrorInfo> getErrorsByContext(String context) {
    return _errors.where((error) => error.context == context).toList();
  }

  // Get recent errors
  List<ErrorInfo> getRecentErrors(int count) {
    final startIndex = _errors.length - count;
    return _errors.skip(startIndex < 0 ? 0 : startIndex).toList();
  }

  // Get errors in time range
  List<ErrorInfo> getErrorsInRange(DateTime start, DateTime end) {
    return _errors.where((error) => 
      error.timestamp.isAfter(start) && error.timestamp.isBefore(end)
    ).toList();
  }

  // Get error count by type
  Map<ErrorType, int> getErrorCountByType() {
    final counts = <ErrorType, int>{};
    
    for (final error in _errors) {
      counts[error.type] = (counts[error.type] ?? 0) + 1;
    }
    
    return counts;
  }

  // Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final counts = getErrorCountByType();
    final total = _errors.length;
    
    return {
      'total_errors': total,
      'error_counts': counts,
      'most_common_type': counts.isNotEmpty 
          ? counts.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : null,
      'oldest_error': _errors.isNotEmpty ? _errors.first.timestamp : null,
      'newest_error': _errors.isNotEmpty ? _errors.last.timestamp : null,
    };
  }

  // Clear all errors
  void clearErrors() {
    _errors.clear();
  }

  // Clear errors by type
  void clearErrorsByType(ErrorType type) {
    _errors.removeWhere((error) => error.type == type);
  }

  // Clear errors by context
  void clearErrorsByContext(String context) {
    _errors.removeWhere((error) => error.context == context);
  }

  // Clear old errors
  void clearOldErrors(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    _errors.removeWhere((error) => error.timestamp.isBefore(cutoff));
  }

  // Search errors
  List<ErrorInfo> searchErrors(String query) {
    return _errors.where((error) => 
      error.message.toLowerCase().contains(query.toLowerCase()) ||
      (error.context?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Get error summary
  Map<String, dynamic> getErrorSummary() {
    final counts = getErrorCountByType();
    final total = _errors.length;
    
    return {
      'total': total,
      'by_type': counts,
      'recent_count': getRecentErrors(10).length,
      'critical_count': getErrorsByType(ErrorType.critical).length,
    };
  }

  // Export errors
  List<Map<String, dynamic>> exportErrors() {
    return _errors.map((error) => error.toMap()).toList();
  }

  // Dispose
  void dispose() {
    _errorController.close();
  }
}

class ErrorInfo {
  final ErrorType type;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final String? context;
  final String? library;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  ErrorInfo({
    required this.type,
    required this.message,
    this.error,
    this.stackTrace,
    this.context,
    this.library,
    this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'message': message,
      'error': error?.toString(),
      'stack_trace': stackTrace?.toString(),
      'context': context,
      'library': library,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

enum ErrorType {
  flutter,
  platform,
  custom,
  network,
  database,
  file,
  validation,
  permission,
  authentication,
  critical,
}