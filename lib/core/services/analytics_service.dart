import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late FirebaseAnalytics _analytics;

  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
  }

  // User events
  Future<void> logUserLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logUserLogout() async {
    await _analytics.logEvent(name: 'user_logout');
  }

  // Bishop events
  Future<void> logBishopAdded(String bishopId, String diocese) async {
    await _analytics.logEvent(
      name: 'bishop_added',
      parameters: {
        'bishop_id': bishopId,
        'diocese': diocese,
      },
    );
  }

  Future<void> logBishopUpdated(String bishopId, String diocese) async {
    await _analytics.logEvent(
      name: 'bishop_updated',
      parameters: {
        'bishop_id': bishopId,
        'diocese': diocese,
      },
    );
  }

  Future<void> logBishopDeleted(String bishopId, String diocese) async {
    await _analytics.logEvent(
      name: 'bishop_deleted',
      parameters: {
        'bishop_id': bishopId,
        'diocese': diocese,
      },
    );
  }

  Future<void> logBishopViewed(String bishopId, String diocese) async {
    await _analytics.logEvent(
      name: 'bishop_viewed',
      parameters: {
        'bishop_id': bishopId,
        'diocese': diocese,
      },
    );
  }

  // Search events
  Future<void> logSearchPerformed(String query, int resultsCount) async {
    await _analytics.logSearch(
      searchTerm: query,
      parameters: {
        'results_count': resultsCount,
      },
    );
  }

  Future<void> logFilterApplied(String filterType, String filterValue) async {
    await _analytics.logEvent(
      name: 'filter_applied',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
      },
    );
  }

  Future<void> logSortApplied(String sortBy, bool ascending) async {
    await _analytics.logEvent(
      name: 'sort_applied',
      parameters: {
        'sort_by': sortBy,
        'ascending': ascending,
      },
    );
  }

  // Report events
  Future<void> logReportGenerated(String reportType, int dataCount) async {
    await _analytics.logEvent(
      name: 'report_generated',
      parameters: {
        'report_type': reportType,
        'data_count': dataCount,
      },
    );
  }

  Future<void> logReportExported(String reportType, String format) async {
    await _analytics.logEvent(
      name: 'report_exported',
      parameters: {
        'report_type': reportType,
        'export_format': format,
      },
    );
  }

  Future<void> logReportPrinted(String reportType) async {
    await _analytics.logEvent(
      name: 'report_printed',
      parameters: {
        'report_type': reportType,
      },
    );
  }

  // Settings events
  Future<void> logThemeChanged(String theme) async {
    await _analytics.logEvent(
      name: 'theme_changed',
      parameters: {
        'theme': theme,
      },
    );
  }

  Future<void> logLanguageChanged(String language) async {
    await _analytics.logEvent(
      name: 'language_changed',
      parameters: {
        'language': language,
      },
    );
  }

  Future<void> logNotificationSettingsChanged(bool enabled) async {
    await _analytics.logEvent(
      name: 'notification_settings_changed',
      parameters: {
        'notifications_enabled': enabled,
      },
    );
  }

  // Data management events
  Future<void> logDataImported(String source, int recordCount) async {
    await _analytics.logEvent(
      name: 'data_imported',
      parameters: {
        'source': source,
        'record_count': recordCount,
      },
    );
  }

  Future<void> logDataExported(String format, int recordCount) async {
    await _analytics.logEvent(
      name: 'data_exported',
      parameters: {
        'export_format': format,
        'record_count': recordCount,
      },
    );
  }

  Future<void> logDataBackupCreated() async {
    await _analytics.logEvent(name: 'data_backup_created');
  }

  Future<void> logDataRestored() async {
    await _analytics.logEvent(name: 'data_restored');
  }

  // Error events
  Future<void> logError(String errorType, String errorMessage) async {
    await _analytics.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
    );
  }

  Future<void> logNetworkError(String operation) async {
    await _analytics.logEvent(
      name: 'network_error',
      parameters: {
        'operation': operation,
      },
    );
  }

  // Performance events
  Future<void> logPageView(String pageName) async {
    await _analytics.logScreenView(screenName: pageName);
  }

  Future<void> logTimeSpent(String pageName, int seconds) async {
    await _analytics.logEvent(
      name: 'time_spent',
      parameters: {
        'page_name': pageName,
        'seconds': seconds,
      },
    );
  }

  // Feature usage events
  Future<void> logFeatureUsed(String featureName) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {
        'feature_name': featureName,
      },
    );
  }

  Future<void> logButtonClicked(String buttonName, String screenName) async {
    await _analytics.logEvent(
      name: 'button_clicked',
      parameters: {
        'button_name': buttonName,
        'screen_name': screenName,
      },
    );
  }

  // Custom events
  Future<void> logCustomEvent(String eventName, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // User properties
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  // App lifecycle events
  Future<void> logAppOpened() async {
    await _analytics.logAppOpen();
  }

  Future<void> logAppBackgrounded() async {
    await _analytics.logEvent(name: 'app_backgrounded');
  }

  Future<void> logAppForegrounded() async {
    await _analytics.logEvent(name: 'app_foregrounded');
  }

  // Conversion events
  Future<void> logConversion(String conversionType, double value) async {
    await _analytics.logEvent(
      name: 'conversion',
      parameters: {
        'conversion_type': conversionType,
        'value': value,
      },
    );
  }

  // E-commerce events (if applicable)
  Future<void> logPurchase(String itemId, String itemName, double value) async {
    await _analytics.logPurchase(
      currency: 'USD',
      value: value,
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
      },
    );
  }
}