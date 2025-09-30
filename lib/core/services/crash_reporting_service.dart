import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashReportingService {
  static final CrashReportingService _instance = CrashReportingService._internal();
  factory CrashReportingService() => _instance;
  CrashReportingService._internal();

  late FirebaseCrashlytics _crashlytics;

  Future<void> initialize() async {
    _crashlytics = FirebaseCrashlytics.instance;
    
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      _crashlytics.recordFlutterFatalError(details);
    };
    
    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    await _crashlytics.recordFlutterError(details);
  }

  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await _crashlytics.setCustomKey(entry.key, entry.value);
    }
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  Future<bool> isCrashlyticsCollectionEnabled() async {
    return await _crashlytics.isCrashlyticsCollectionEnabled();
  }

  Future<void> checkForUnsentReports() async {
    await _crashlytics.checkForUnsentReports();
  }

  Future<void> sendUnsentReports() async {
    await _crashlytics.sendUnsentReports();
  }

  Future<void> deleteUnsentReports() async {
    await _crashlytics.deleteUnsentReports();
  }

  // Custom error reporting methods
  Future<void> reportBishopOperationError(
    String operation,
    String bishopId,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('operation', operation);
    await _crashlytics.setCustomKey('bishop_id', bishopId);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportDatabaseError(
    String operation,
    String table,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('operation', operation);
    await _crashlytics.setCustomKey('table', table);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportNetworkError(
    String endpoint,
    int statusCode,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('endpoint', endpoint);
    await _crashlytics.setCustomKey('status_code', statusCode);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportFileOperationError(
    String operation,
    String filePath,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('operation', operation);
    await _crashlytics.setCustomKey('file_path', filePath);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportExportError(
    String format,
    int recordCount,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('export_format', format);
    await _crashlytics.setCustomKey('record_count', recordCount);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportAuthenticationError(
    String method,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('auth_method', method);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportPermissionError(
    String permission,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('permission', permission);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportValidationError(
    String field,
    String value,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('field', field);
    await _crashlytics.setCustomKey('value', value);
    await _crashlytics.recordError(error, stackTrace);
  }

  Future<void> reportUnexpectedError(
    String context,
    dynamic error,
    StackTrace? stackTrace,
  ) async {
    await _crashlytics.setCustomKey('context', context);
    await _crashlytics.recordError(error, stackTrace);
  }

  // Performance monitoring
  Future<void> startTrace(String traceName) async {
    await _crashlytics.startTrace(traceName);
  }

  Future<void> stopTrace(String traceName) async {
    await _crashlytics.stopTrace(traceName);
  }

  Future<void> setTraceAttribute(String traceName, String attribute, String value) async {
    await _crashlytics.setTraceAttribute(traceName, attribute, value);
  }

  Future<void> incrementTraceMetric(String traceName, String metricName, int value) async {
    await _crashlytics.incrementTraceMetric(traceName, metricName, value);
  }

  // App state tracking
  Future<void> setAppState(String state) async {
    await _crashlytics.setCustomKey('app_state', state);
  }

  Future<void> setUserRole(String role) async {
    await _crashlytics.setCustomKey('user_role', role);
  }

  Future<void> setAppVersion(String version) async {
    await _crashlytics.setCustomKey('app_version', version);
  }

  Future<void> setDeviceInfo(String platform, String version) async {
    await _crashlytics.setCustomKey('platform', platform);
    await _crashlytics.setCustomKey('platform_version', version);
  }

  // Test methods (for development only)
  Future<void> testCrash() async {
    if (kDebugMode) {
      await _crashlytics.crash();
    }
  }

  Future<void> testNonFatalError() async {
    if (kDebugMode) {
      await _crashlytics.recordError(
        'Test non-fatal error',
        StackTrace.current,
        fatal: false,
      );
    }
  }
}