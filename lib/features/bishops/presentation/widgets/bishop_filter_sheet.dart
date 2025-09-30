import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/bishop_provider.dart';
import '../../domain/entities/bishop_filter.dart';

class BishopFilterSheet extends ConsumerStatefulWidget {
  const BishopFilterSheet({super.key});

  @override
  ConsumerState<BishopFilterSheet> createState() => _BishopFilterSheetState();
}

class _BishopFilterSheetState extends ConsumerState<BishopFilterSheet> {
  String? _selectedDiocese;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(bishopFilterProvider);
    _selectedDiocese = filter.diocese;
    _startDate = filter.startDate;
    _endDate = filter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final diocesesAsync = ref.watch(diocesesProvider);

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
                l10n.filter,
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
          
          // Diocese Filter
          Text(
            l10n.filterByDiocese,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          diocesesAsync.when(
            data: (dioceses) => _buildDioceseDropdown(dioceses),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('خطأ في تحميل الأبرشيات: $error'),
          ),
          
          const SizedBox(height: 24),
          
          // Date Range Filter
          Text(
            l10n.filterByDate,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildDateRangeFilter(),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.clear),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
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
        ],
      ),
    );
  }

  Widget _buildDioceseDropdown(List<String> dioceses) {
    return DropdownButtonFormField<String>(
      value: _selectedDiocese,
      decoration: InputDecoration(
        hintText: 'اختر الأبرشية',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('جميع الأبرشيات'),
        ),
        ...dioceses.map((diocese) => DropdownMenuItem<String>(
          value: diocese,
          child: Text(diocese),
        )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedDiocese = value;
        });
      },
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      children: [
        // Start Date
        InkWell(
          onTap: _selectStartDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _startDate != null
                        ? _formatDate(_startDate!)
                        : 'تاريخ البداية',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _startDate != null
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textHintColor,
                    ),
                  ),
                ),
                if (_startDate != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _startDate = null;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 20),
                  ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // End Date
        InkWell(
          onTap: _selectEndDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _endDate != null
                        ? _formatDate(_endDate!)
                        : 'تاريخ النهاية',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _endDate != null
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textHintColor,
                    ),
                  ),
                ),
                if (_endDate != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _endDate = null;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 20),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDiocese = null;
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    ref.read(bishopFilterProvider.notifier).updateDiocese(_selectedDiocese);
    ref.read(bishopFilterProvider.notifier).updateDateRange(_startDate, _endDate);
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
