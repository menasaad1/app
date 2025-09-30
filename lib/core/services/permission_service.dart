import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  // Storage permissions
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> isStoragePermissionGranted() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  // Photos permission
  Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<bool> isPhotosPermissionGranted() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  // Notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> isMicrophonePermissionGranted() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Multiple permissions
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  Future<bool> areAllPermissionsGranted(List<Permission> permissions) async {
    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  // Check permission status
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  // Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  // Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  // Check if permission is restricted
  Future<bool> isPermissionRestricted(Permission permission) async {
    final status = await permission.status;
    return status.isRestricted;
  }

  // Request permission with rationale
  Future<bool> requestPermissionWithRationale(
    Permission permission,
    String rationale,
  ) async {
    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final newStatus = await permission.request();
      return newStatus.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      // Show rationale and open settings
      return false;
    }
    
    return false;
  }

  // App-specific permission methods
  Future<bool> requestPhotoCapturePermissions() async {
    final permissions = [Permission.camera, Permission.storage];
    final statuses = await permissions.request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  Future<bool> requestFileAccessPermissions() async {
    final permissions = [Permission.storage, Permission.manageExternalStorage];
    final statuses = await permissions.request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  Future<bool> requestAllAppPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.notification,
    ];
    
    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  // Check if all required permissions are granted
  Future<bool> checkAllRequiredPermissions() async {
    final requiredPermissions = [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ];
    
    for (final permission in requiredPermissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
    }
    
    return true;
  }

  // Get permission status message
  String getPermissionStatusMessage(Permission permission, PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'تم منح الإذن';
      case PermissionStatus.denied:
        return 'تم رفض الإذن';
      case PermissionStatus.restricted:
        return 'الإذن مقيد';
      case PermissionStatus.limited:
        return 'الإذن محدود';
      case PermissionStatus.permanentlyDenied:
        return 'تم رفض الإذن نهائياً';
      case PermissionStatus.provisional:
        return 'الإذن مؤقت';
    }
  }

  // Get permission name in Arabic
  String getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'الكاميرا';
      case Permission.storage:
        return 'التخزين';
      case Permission.photos:
        return 'الصور';
      case Permission.notification:
        return 'الإشعارات';
      case Permission.location:
        return 'الموقع';
      case Permission.microphone:
        return 'الميكروفون';
      default:
        return 'إذن غير معروف';
    }
  }

  // Check if permission is essential for app functionality
  bool isEssentialPermission(Permission permission) {
    const essentialPermissions = [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ];
    
    return essentialPermissions.contains(permission);
  }

  // Get permission rationale message
  String getPermissionRationale(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'نحتاج إذن الكاميرا لالتقاط صور الأساقفة';
      case Permission.storage:
        return 'نحتاج إذن التخزين لحفظ البيانات والملفات';
      case Permission.photos:
        return 'نحتاج إذن الصور لاختيار صور الأساقفة من المعرض';
      case Permission.notification:
        return 'نحتاج إذن الإشعارات لإرسال تنبيهات مهمة';
      case Permission.location:
        return 'نحتاج إذن الموقع لتحديد موقع الأبرشيات';
      case Permission.microphone:
        return 'نحتاج إذن الميكروفون لتسجيل الملاحظات الصوتية';
      default:
        return 'نحتاج هذا الإذن لتشغيل التطبيق بشكل صحيح';
    }
  }
}