import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/bishop_provider.dart';
import '../../domain/entities/bishop_filter.dart';

class BishopSortSheet extends ConsumerWidget {
  const BishopSortSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(bishopFilterProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.sortBy,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Sort Options
          _buildSortOption(
            context,
            'الاسم',
            BishopSortBy.name,
            filter.sortBy == BishopSortBy.name,
            () {
              ref.read(bishopFilterProvider.notifier).updateSortBy(BishopSortBy.name);
            },
          ),
          
          _buildSortOption(
            context,
            'تاريخ الرسامة',
            BishopSortBy.ordinationDate,
            filter.sortBy == BishopSortBy.ordinationDate,
            () {
              ref.read(bishopFilterProvider.notifier).updateSortBy(BishopSortBy.ordinationDate);
            },
          ),
          
          _buildSortOption(
            context,
            'الأبرشية',
            BishopSortBy.diocese,
            filter.sortBy == BishopSortBy.diocese,
            () {
              ref.read(bishopFilterProvider.notifier).updateSortBy(BishopSortBy.diocese);
            },
          ),
          
          _buildSortOption(
            context,
            'تاريخ الإضافة',
            BishopSortBy.createdAt,
            filter.sortBy == BishopSortBy.createdAt,
            () {
              ref.read(bishopFilterProvider.notifier).updateSortBy(BishopSortBy.createdAt);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Sort Order
          Text(
            'ترتيب',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSortOrderOption(
                  context,
                  'تصاعدي',
                  true,
                  filter.ascending,
                  () {
                    ref.read(bishopFilterProvider.notifier).updateSortOrder(true);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSortOrderOption(
                  context,
                  'تنازلي',
                  false,
                  !filter.ascending,
                  () {
                    ref.read(bishopFilterProvider.notifier).updateSortOrder(false);
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.apply),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    BishopSortBy sortBy,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOrderOption(
    BuildContext context,
    String title,
    bool isAscending,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
