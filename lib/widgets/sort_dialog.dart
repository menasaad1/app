import 'package:flutter/material.dart';

class SortDialog extends StatefulWidget {
  final String currentSortBy;
  final bool currentAscending;
  final Function(String sortBy, bool ascending) onSortChanged;

  const SortDialog({
    super.key,
    required this.currentSortBy,
    required this.currentAscending,
    required this.onSortChanged,
  });

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  late String _selectedSortBy;
  late bool _ascending;

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.currentSortBy;
    _ascending = widget.currentAscending;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'ترتيب القائمة',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ترتيب حسب:',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            title: const Text(
              'تاريخ الرسامة',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            value: 'ordinationDate',
            groupValue: _selectedSortBy,
            onChanged: (value) {
              setState(() {
                _selectedSortBy = value!;
              });
            },
            activeColor: Colors.deepPurple,
          ),
          RadioListTile<String>(
            title: const Text(
              'الاسم',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            value: 'name',
            groupValue: _selectedSortBy,
            onChanged: (value) {
              setState(() {
                _selectedSortBy = value!;
              });
            },
            activeColor: Colors.deepPurple,
          ),
          const SizedBox(height: 16),
          const Text(
            'اتجاه الترتيب:',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<bool>(
            title: const Text(
              'تصاعدي (من الأقدم إلى الأحدث)',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            value: true,
            groupValue: _ascending,
            onChanged: (value) {
              setState(() {
                _ascending = value!;
              });
            },
            activeColor: Colors.deepPurple,
          ),
          RadioListTile<bool>(
            title: const Text(
              'تنازلي (من الأحدث إلى الأقدم)',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            value: false,
            groupValue: _ascending,
            onChanged: (value) {
              setState(() {
                _ascending = value!;
              });
            },
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إلغاء',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSortChanged(_selectedSortBy, _ascending);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'تطبيق',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }
}

