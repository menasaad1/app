import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bishops/presentation/providers/bishop_provider.dart';
import '../widgets/report_card.dart';
import '../widgets/statistics_chart.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bishopsAsync = ref.watch(bishopsProvider(null));
    final statisticsAsync = ref.watch(bishopStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(bishopsProvider);
              ref.invalidate(bishopStatisticsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(bishopsProvider);
          ref.invalidate(bishopStatisticsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Actions
              _buildQuickActions(context, l10n),
              
              const SizedBox(height: 24),
              
              // Statistics Overview
              _buildStatisticsOverview(context, l10n, statisticsAsync),
              
              const SizedBox(height: 24),
              
              // Charts Section
              _buildChartsSection(context, l10n, statisticsAsync),
              
              const SizedBox(height: 24),
              
              // Detailed Reports
              _buildDetailedReports(context, l10n, bishopsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإجراءات السريعة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ReportCard(
                title: l10n.exportToPdf,
                icon: Icons.picture_as_pdf,
                color: AppTheme.errorColor,
                onTap: () => _exportToPdf(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ReportCard(
                title: l10n.exportToExcel,
                icon: Icons.table_chart,
                color: AppTheme.successColor,
                onTap: () => _exportToExcel(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ReportCard(
                title: l10n.printReport,
                icon: Icons.print,
                color: AppTheme.secondaryColor,
                onTap: () => _printReport(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ReportCard(
                title: 'إحصائيات متقدمة',
                icon: Icons.analytics,
                color: AppTheme.infoColor,
                onTap: () => _showAdvancedStatistics(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsOverview(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<Map<String, int>> statisticsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.statistics,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        statisticsAsync.when(
          data: (statistics) => _buildStatisticsCards(context, statistics),
          loading: () => _buildStatisticsLoading(context),
          error: (error, stack) => _buildStatisticsError(context, error),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(BuildContext context, Map<String, int> statistics) {
    final totalBishops = statistics.values.fold(0, (sum, count) => sum + count);
    final totalDioceses = statistics.length;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'إجمالي الأساقفة',
                totalBishops.toString(),
                Icons.people,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'عدد الأبرشيات',
                totalDioceses.toString(),
                Icons.location_city,
                AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'متوسط الأساقفة لكل أبرشية',
                totalDioceses > 0 ? (totalBishops / totalDioceses).toStringAsFixed(1) : '0',
                Icons.trending_up,
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'أكبر أبرشية',
                statistics.isNotEmpty
                    ? statistics.entries.reduce((a, b) => a.value > b.value ? a : b).key
                    : 'لا توجد',
                Icons.emoji_events,
                AppTheme.warningColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsLoading(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCardSkeleton(context)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCardSkeleton(context)),
      ],
    );
  }

  Widget _buildStatCardSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsError(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'فشل في تحميل الإحصائيات',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<Map<String, int>> statisticsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الرسوم البيانية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        statisticsAsync.when(
          data: (statistics) => StatisticsChart(data: statistics),
          loading: () => _buildChartLoading(context),
          error: (error, stack) => _buildChartError(context),
        ),
      ],
    );
  }

  Widget _buildChartLoading(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildChartError(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'فشل في تحميل الرسم البياني',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReports(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<dynamic>> bishopsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقارير التفصيلية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        bishopsAsync.when(
          data: (bishops) => _buildDetailedReportsList(context, bishops),
          loading: () => _buildDetailedReportsLoading(context),
          error: (error, stack) => _buildDetailedReportsError(context),
        ),
      ],
    );
  }

  Widget _buildDetailedReportsList(BuildContext context, List<dynamic> bishops) {
    return Column(
      children: [
        _buildReportItem(
          context,
          'تقرير شامل للأساقفة',
          'عرض جميع بيانات الأساقفة مع التفاصيل الكاملة',
          Icons.description,
          () => _generateComprehensiveReport(context, bishops),
        ),
        const SizedBox(height: 12),
        _buildReportItem(
          context,
          'تقرير الأبرشيات',
          'توزيع الأساقفة حسب الأبرشيات',
          Icons.location_city,
          () => _generateDioceseReport(context, bishops),
        ),
        const SizedBox(height: 12),
        _buildReportItem(
          context,
          'تقرير التواريخ',
          'الأساقفة حسب تواريخ الرسامة',
          Icons.calendar_today,
          () => _generateDateReport(context, bishops),
        ),
      ],
    );
  }

  Widget _buildReportItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReportsLoading(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => _buildReportItemSkeleton(context)),
    );
  }

  Widget _buildReportItemSkeleton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedReportsError(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'فشل في تحميل التقارير',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportToPdf(BuildContext context) {
    // TODO: Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة ميزة التصدير إلى PDF قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _exportToExcel(BuildContext context) {
    // TODO: Implement Excel export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة ميزة التصدير إلى Excel قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _printReport(BuildContext context) {
    // TODO: Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة ميزة الطباعة قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showAdvancedStatistics(BuildContext context) {
    // TODO: Implement advanced statistics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة الإحصائيات المتقدمة قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _generateComprehensiveReport(BuildContext context, List<dynamic> bishops) {
    // TODO: Implement comprehensive report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة التقرير الشامل قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _generateDioceseReport(BuildContext context, List<dynamic> bishops) {
    // TODO: Implement diocese report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة تقرير الأبرشيات قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _generateDateReport(BuildContext context, List<dynamic> bishops) {
    // TODO: Implement date report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة تقرير التواريخ قريباً'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
}
