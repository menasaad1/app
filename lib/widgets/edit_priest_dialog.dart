import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/priest.dart';
import '../providers/priests_provider.dart';

class EditPriestDialog extends StatefulWidget {
  final Priest priest;

  const EditPriestDialog({
    super.key,
    required this.priest,
  });

  @override
  State<EditPriestDialog> createState() => _EditPriestDialogState();
}

class _EditPriestDialogState extends State<EditPriestDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _churchController;
  late final TextEditingController _rankController;
  late final TextEditingController _notesController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.priest.name);
    _churchController = TextEditingController(text: widget.priest.church ?? '');
    _rankController = TextEditingController(text: widget.priest.rank ?? '');
    _notesController = TextEditingController(text: widget.priest.notes ?? '');
    _selectedDate = widget.priest.ordinationDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _churchController.dispose();
    _rankController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'تعديل بيانات الأب الكاهن',
        style: TextStyle(
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم الأب الكاهن *',
                  hintText: 'أدخل اسم الأب الكاهن',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم الأب الكاهن';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Rank Field
              TextFormField(
                controller: _rankController,
                decoration: InputDecoration(
                  labelText: 'الرتبة',
                  hintText: 'مثال: قمص، أبونا، إلخ',
                  prefixIcon: const Icon(Icons.star),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Church Field
              TextFormField(
                controller: _churchController,
                decoration: InputDecoration(
                  labelText: 'الكنيسة',
                  hintText: 'أدخل اسم الكنيسة',
                  prefixIcon: const Icon(Icons.church),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Ordination Date Field
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(
                        'تاريخ الرسامة: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notes Field
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'ملاحظات',
                  hintText: 'أدخل أي ملاحظات إضافية',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'إلغاء',
            style: TextStyle(fontFamily: 'Arial'),
          ),
        ),
        Consumer<PriestsProvider>(
          builder: (context, priestsProvider, child) {
            return ElevatedButton(
              onPressed: priestsProvider.isLoading ? null : _updatePriest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: priestsProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'حفظ التغييرات',
                      style: TextStyle(fontFamily: 'Arial'),
                    ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updatePriest() async {
    if (_formKey.currentState!.validate()) {
      final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
      
      final updatedPriest = widget.priest.copyWith(
        name: _nameController.text.trim(),
        ordinationDate: _selectedDate,
        church: _churchController.text.trim().isEmpty ? null : _churchController.text.trim(),
        rank: _rankController.text.trim().isEmpty ? null : _rankController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        updatedAt: DateTime.now(),
      );

      final success = await priestsProvider.updatePriest(updatedPriest);
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم تحديث بيانات الأب الكاهن بنجاح',
              style: TextStyle(fontFamily: 'Arial'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              priestsProvider.errorMessage ?? 'حدث خطأ في تحديث الأب الكاهن',
              style: const TextStyle(fontFamily: 'Arial'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
