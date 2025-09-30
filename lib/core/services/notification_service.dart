import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> requestPermissions() async {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Handle permission denied
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'bishops_channel',
      'إشعارات الأساقفة',
      channelDescription: 'إشعارات تطبيق إدارة الأساقفة',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> showBishopAddedNotification(String bishopName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'تم إضافة أسقف جديد',
      body: 'تم إضافة الأسقف $bishopName بنجاح',
      payload: 'bishop_added',
    );
  }

  Future<void> showBishopUpdatedNotification(String bishopName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'تم تحديث بيانات الأسقف',
      body: 'تم تحديث بيانات الأسقف $bishopName',
      payload: 'bishop_updated',
    );
  }

  Future<void> showBishopDeletedNotification(String bishopName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'تم حذف الأسقف',
      body: 'تم حذف الأسقف $bishopName',
      payload: 'bishop_deleted',
    );
  }

  Future<void> showReportGeneratedNotification(String reportType) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'تم إنشاء التقرير',
      body: 'تم إنشاء تقرير $reportType بنجاح',
      payload: 'report_generated',
    );
  }

  Future<void> showDataBackupNotification() async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'تم إنشاء نسخة احتياطية',
      body: 'تم إنشاء نسخة احتياطية من البيانات بنجاح',
      payload: 'data_backup',
    );
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'bishops_scheduled',
      'إشعارات مجدولة',
      channelDescription: 'إشعارات مجدولة لتطبيق إدارة الأساقفة',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate based on payload
      switch (payload) {
        case 'bishop_added':
        case 'bishop_updated':
        case 'bishop_deleted':
          // Navigate to bishops page
          break;
        case 'report_generated':
          // Navigate to reports page
          break;
        case 'data_backup':
          // Navigate to settings page
          break;
      }
    }
  }
}
