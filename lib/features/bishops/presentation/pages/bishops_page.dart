import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/bishop_provider.dart';
import '../widgets/bishop_card.dart';
import '../widgets/bishop_search_bar.dart';
import '../widgets/bishop_filter_sheet.dart';
import '../widgets/bishop_sort_sheet.dart';
import '../../domain/entities/bishop.dart';
import '../../domain/entities/bishop_filter.dart';

class BishopsPage extends ConsumerStatefulWidget {
  const BishopsPage({super.key});

  @override
  ConsumerState<BishopsPage> createState() => _BishopsPageState();
}

class _BishopsPageState extends ConsumerState<BishopsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(bishopFilterProvider);
    final bishopsAsync = ref.watch(bishopsProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bishops),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchBar,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchAndFilterBar(context, l10n),
          
          // Bishops List
          Expanded(
            child: bishopsAsync.when(
              data: (bishops) => _buildBishopsList(context, bishops),
              loading: () => _buildLoadingState(context),
              error: (error, stack) => _buildErrorState(context, error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/bishops/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, AppLocalizations l10n) {
    final filter = ref.watch(bishopFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              ref.read(bishopFilterProvider.notifier).updateSearchQuery(value);
            },
            decoration: InputDecoration(
              hintText: l10n.searchBishops,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filter.searchQuery?.isNotEmpty == true
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref.read(bishopFilterProvider.notifier).updateSearchQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Filter Chips
          _buildFilterChips(context, l10n, filter),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, AppLocalizations l10n, BishopFilter filter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Diocese Filter
          if (filter.diocese != null)
            Chip(
              label: Text(filter.diocese!),
              onDeleted: () {
                ref.read(bishopFilterProvider.notifier).updateDiocese(null);
              },
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          
          if (filter.diocese != null) const SizedBox(width: 8),
          
          // Date Range Filter
          if (filter.startDate != null || filter.endDate != null)
            Chip(
              label: Text(
                filter.startDate != null && filter.endDate != null
                    ? '${_formatDate(filter.startDate!)} - ${_formatDate(filter.endDate!)}'
                    : filter.startDate != null
                        ? 'من ${_formatDate(filter.startDate!)}'
                        : 'حتى ${_formatDate(filter.endDate!)}',
              ),
              onDeleted: () {
                ref.read(bishopFilterProvider.notifier).updateDateRange(null, null);
              },
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          
          if (filter.startDate != null || filter.endDate != null) const SizedBox(width: 8),
          
          // Sort Filter
          Chip(
            label: Text('${_getSortLabel(filter.sortBy)} ${filter.ascending ? '↑' : '↓'}'),
            onDeleted: () {
              ref.read(bishopFilterProvider.notifier).updateSortBy(BishopSortBy.name);
              ref.read(bishopFilterProvider.notifier).updateSortOrder(true);
            },
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
          
          const SizedBox(width: 8),
          
          // Clear All Filters
          if (filter.diocese != null || filter.startDate != null || filter.endDate != null)
            ActionChip(
              label: Text(l10n.clear),
              onPressed: () {
                ref.read(bishopFilterProvider.notifier).clearFilters();
              },
              backgroundColor: AppTheme.errorColor.withOpacity(0.1),
              labelStyle: TextStyle(color: AppTheme.errorColor),
            ),
        ],
      ),
    );
  }

  String _getSortLabel(BishopSortBy sortBy) {
    switch (sortBy) {
      case BishopSortBy.name:
        return 'الاسم';
      case BishopSortBy.ordinationDate:
        return 'تاريخ الرسامة';
      case BishopSortBy.diocese:
        return 'الأبرشية';
      case BishopSortBy.createdAt:
        return 'تاريخ الإضافة';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildBishopsList(BuildContext context, List<Bishop> bishops) {
    if (bishops.isEmpty) {
      return _buildEmptyState(context);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: bishops.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BishopCard(
              bishop: bishops[index],
              onTap: () => context.go('/bishops/${bishops[index].id}'),
              onEdit: () => context.go('/bishops/${bishops[index].id}/edit'),
              onDelete: () => _showDeleteDialog(context, bishops[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الأساقفة...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل الأساقفة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(bishopsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أساقفة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة أول أسقف',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/bishops/add'),
            icon: const Icon(Icons.add),
            label: const Text('إضافة أسقف'),
          ),
        ],
      ),
    );
  }

  void _showSearchBar() {
    // Implement search bar functionality
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BishopFilterSheet(),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BishopSortSheet(),
    );
  }

  void _showDeleteDialog(BuildContext context, Bishop bishop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الأسقف ${bishop.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(bishopActionsProvider.notifier).deleteBishop(bishop.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف الأسقف بنجاح'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
