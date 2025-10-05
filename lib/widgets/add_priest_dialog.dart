import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/priest.dart';
import '../providers/priests_provider.dart';

class AddPriestDialog extends StatefulWidget {
  const AddPriestDialog({super.key});

  @override
  State<AddPriestDialog> createState() => _AddPriestDialogState();
}

class _AddPriestDialogState extends State<AddPriestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _churchController = TextEditingController();
  final _rankController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
        'إضافة أب كاهن جديد',
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
              onPressed: priestsProvider.isLoading ? null : _addPriest,
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
                      'إضافة',
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

  Future<void> _addPriest() async {
    if (_formKey.currentState!.validate()) {
      final priestsProvider = Provider.of<PriestsProvider>(context, listen: false);
      
      final priest = Priest(
        id: '', // Will be set by Firestore
        name: _nameController.text.trim(),
        ordinationDate: _selectedDate,
        church: _churchController.text.trim().isEmpty ? null : _churchController.text.trim(),
        rank: _rankController.text.trim().isEmpty ? null : _rankController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await priestsProvider.addPriest(priest);
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم إضافة الأب الكاهن بنجاح',
              style: TextStyle(fontFamily: 'Arial'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              priestsProvider.errorMessage ?? 'حدث خطأ في إضافة الأب الكاهن',
              style: const TextStyle(fontFamily: 'Arial'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
