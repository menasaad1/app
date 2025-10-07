import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bishops_provider.dart';
import '../providers/priests_provider.dart';
import '../services/realtime_service.dart';
import '../utils/app_colors.dart';

class RealtimeManagementScreen extends StatefulWidget {
  const RealtimeManagementScreen({super.key});

  @override
  State<RealtimeManagementScreen> createState() => _RealtimeManagementScreenState();
}

class _RealtimeManagementScreenState extends State<RealtimeManagementScreen> {
  bool _isRealtimeEnabled = true;
  String _lastUpdateTime = '';
  int _updateCount = 0;

  @override
  void initState() {
    super.initState();
    _checkRealtimeStatus();
  }

  void _checkRealtimeStatus() {
    // This would check if realtime updates are currently active
    setState(() {
      _isRealtimeEnabled = true; // Assume enabled by default
      _lastUpdateTime = DateTime.now().toString().split('.')[0];
    });
  }

  void _toggleRealtimeUpdates() {
    setState(() {
      _isRealtimeEnabled = !_isRealtimeEnabled;
    });

    if (_isRealtimeEnabled) {
      // Start realtime updates
      final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
      final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
      
      bishopsProvider.fetchBishops();
      priestsProvider.fetchPriests();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تفعيل التحديثات المباشرة'),
          backgroundColor: AppColors.statusActive,
        ),
      );
    } else {
      // Stop realtime updates
      RealtimeService.stopRealtimeUpdates();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إيقاف التحديثات المباشرة'),
          backgroundColor: AppColors.statusInactive,
        ),
      );
    }
  }

  void _refreshData() {
    final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
    final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
    
    bishopsProvider.fetchBishops();
    priestsProvider.fetchPriests();
    
    setState(() {
      _updateCount++;
      _lastUpdateTime = DateTime.now().toString().split('.')[0];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديث البيانات'),
        backgroundColor: AppColors.statusActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'إدارة التحديثات المباشرة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isRealtimeEnabled ? Icons.sync : Icons.sync_disabled,
                        color: _isRealtimeEnabled ? AppColors.statusActive : AppColors.statusInactive,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isRealtimeEnabled ? 'التحديثات المباشرة مفعلة' : 'التحديثات المباشرة معطلة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isRealtimeEnabled ? AppColors.statusActive : AppColors.statusInactive,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  if (_lastUpdateTime.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'آخر تحديث: $_lastUpdateTime',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                  if (_updateCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'عدد التحديثات: $_updateCount',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Controls
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التحكم في التحديثات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Toggle Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleRealtimeUpdates,
                      icon: Icon(
                        _isRealtimeEnabled ? Icons.sync_disabled : Icons.sync,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isRealtimeEnabled ? 'إيقاف التحديثات المباشرة' : 'تفعيل التحديثات المباشرة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRealtimeEnabled ? AppColors.statusInactive : AppColors.statusActive,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Refresh Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh, color: AppColors.primaryPurple),
                      label: const Text(
                        'تحديث البيانات الآن',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primaryPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'معلومات مهمة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• التحديثات المباشرة تسمح بالحصول على أحدث البيانات فوراً\n• عند إيقاف التحديثات، ستحتاج لتحديث البيانات يدوياً\n• التحديثات تعمل فقط عند وجود اتصال بالإنترنت\n• البيانات المحلية تعمل كنسخة احتياطية',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
