import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();

  // Check if device is connected to internet
  Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // Check if device is connected to WiFi
  Future<bool> isConnectedToWiFi() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi;
    } catch (e) {
      return false;
    }
  }

  // Check if device is connected to mobile data
  Future<bool> isConnectedToMobile() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      return false;
    }
  }

  // Check if device is connected to Ethernet
  Future<bool> isConnectedToEthernet() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.ethernet;
    } catch (e) {
      return false;
    }
  }

  // Get current connection type
  Future<ConnectivityResult> getConnectionType() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  // Get connection type name
  String getConnectionTypeName(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'البيانات الخلوية';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'أخرى';
      case ConnectivityResult.none:
        return 'غير متصل';
    }
  }

  // Check if device can reach a specific host
  Future<bool> canReachHost(String host, {int port = 80, Duration timeout = const Duration(seconds: 5)}) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if device can reach Google DNS
  Future<bool> canReachGoogleDNS() async {
    return await canReachHost('8.8.8.8', port: 53);
  }

  // Check if device can reach Cloudflare DNS
  Future<bool> canReachCloudflareDNS() async {
    return await canReachHost('1.1.1.1', port: 53);
  }

  // Check if device can reach a specific URL
  Future<bool> canReachUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await canReachHost(uri.host, port: uri.port);
    } catch (e) {
      return false;
    }
  }

  // Get network quality based on connection type
  String getNetworkQuality(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'ممتاز';
      case ConnectivityResult.ethernet:
        return 'ممتاز';
      case ConnectivityResult.mobile:
        return 'جيد';
      case ConnectivityResult.bluetooth:
        return 'ضعيف';
      case ConnectivityResult.vpn:
        return 'متوسط';
      case ConnectivityResult.other:
        return 'غير معروف';
      case ConnectivityResult.none:
        return 'غير متصل';
    }
  }

  // Check if device is on a metered connection
  Future<bool> isMeteredConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      return false;
    }
  }

  // Get network speed estimate
  Future<String> getNetworkSpeedEstimate() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          return 'سريع';
        case ConnectivityResult.ethernet:
          return 'سريع جداً';
        case ConnectivityResult.mobile:
          return 'متوسط';
        case ConnectivityResult.bluetooth:
          return 'بطيء';
        case ConnectivityResult.vpn:
          return 'متغير';
        case ConnectivityResult.other:
          return 'غير معروف';
        case ConnectivityResult.none:
          return 'غير متصل';
      }
    } catch (e) {
      return 'غير معروف';
    }
  }

  // Check if device is on a slow connection
  Future<bool> isSlowConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.bluetooth ||
             connectivityResult == ConnectivityResult.other;
    } catch (e) {
      return false;
    }
  }

  // Check if device is on a fast connection
  Future<bool> isFastConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi ||
             connectivityResult == ConnectivityResult.ethernet;
    } catch (e) {
      return false;
    }
  }

  // Get network status message
  Future<String> getNetworkStatusMessage() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          return 'متصل عبر WiFi';
        case ConnectivityResult.mobile:
          return 'متصل عبر البيانات الخلوية';
        case ConnectivityResult.ethernet:
          return 'متصل عبر Ethernet';
        case ConnectivityResult.bluetooth:
          return 'متصل عبر Bluetooth';
        case ConnectivityResult.vpn:
          return 'متصل عبر VPN';
        case ConnectivityResult.other:
          return 'متصل عبر اتصال آخر';
        case ConnectivityResult.none:
          return 'غير متصل بالإنترنت';
      }
    } catch (e) {
      return 'خطأ في فحص الاتصال';
    }
  }

  // Check if device should use low data mode
  Future<bool> shouldUseLowDataMode() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile ||
             connectivityResult == ConnectivityResult.bluetooth;
    } catch (e) {
      return false;
    }
  }

  // Check if device should cache data
  Future<bool> shouldCacheData() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile ||
             connectivityResult == ConnectivityResult.bluetooth ||
             connectivityResult == ConnectivityResult.other;
    } catch (e) {
      return true; // Default to caching when in doubt
    }
  }

  // Check if device should sync data
  Future<bool> shouldSyncData() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi ||
             connectivityResult == ConnectivityResult.ethernet;
    } catch (e) {
      return false; // Default to not syncing when in doubt
    }
  }

  // Get network recommendations
  Future<List<String>> getNetworkRecommendations() async {
    final recommendations = <String>[];
    
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      switch (connectivityResult) {
        case ConnectivityResult.none:
          recommendations.add('تحقق من اتصالك بالإنترنت');
          recommendations.add('تأكد من تشغيل WiFi أو البيانات الخلوية');
          break;
        case ConnectivityResult.mobile:
          recommendations.add('استخدم WiFi للحصول على سرعة أفضل');
          recommendations.add('تأكد من وجود رصيد كافي');
          break;
        case ConnectivityResult.bluetooth:
          recommendations.add('استخدم WiFi للحصول على سرعة أفضل');
          break;
        case ConnectivityResult.other:
          recommendations.add('تحقق من جودة الاتصال');
          break;
        case ConnectivityResult.wifi:
        case ConnectivityResult.ethernet:
        case ConnectivityResult.vpn:
          // No recommendations for good connections
          break;
      }
    } catch (e) {
      recommendations.add('تحقق من إعدادات الشبكة');
    }
    
    return recommendations;
  }
}