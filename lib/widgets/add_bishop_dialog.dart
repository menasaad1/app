import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/bishops_provider.dart';
import '../models/bishop.dart';

class AddBishopDialog extends StatefulWidget {
  const AddBishopDialog({super.key});

  @override
  State<AddBishopDialog> createState() => _AddBishopDialogState();
}

class _AddBishopDialogState extends State<AddBishopDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dioceseController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _dioceseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
        'إضافة أب أسقف جديد',
        style: TextStyle(
          fontFamily: 'Cairo',
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
                  labelText: 'اسم الأب الأسقف *',
                  hintText: 'أدخل اسم الأب الأسقف',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال اسم الأب الأسقف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Diocese Field
              TextFormField(
                controller: _dioceseController,
                decoration: InputDecoration(
                  labelText: 'الأسقفية (اختياري)',
                  hintText: 'أدخل اسم الأسقفية',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Ordination Date
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'تاريخ الرسامة *',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              DateFormat('yyyy/MM/dd', 'ar').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
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
                  labelText: 'ملاحظات (اختياري)',
                  hintText: 'أدخل أي ملاحظات إضافية',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
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
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey,
            ),
          ),
        ),
        Consumer<BishopsProvider>(
          builder: (context, bishopsProvider, child) {
            return ElevatedButton(
              onPressed: bishopsProvider.isLoading ? null : _addBishop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: bishopsProvider.isLoading
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
                      style: TextStyle(fontFamily: 'Cairo'),
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

  Future<void> _addBishop() async {
    if (_formKey.currentState!.validate()) {
      final bishopsProvider = Provider.of<BishopsProvider>(context, listen: false);
      
      final bishop = Bishop(
        id: '', // Will be generated by Firestore
        name: _nameController.text.trim(),
        ordinationDate: _selectedDate,
        diocese: _dioceseController.text.trim().isEmpty ? null : _dioceseController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await bishopsProvider.addBishop(bishop);
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم إضافة الأب الأسقف بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bishopsProvider.errorMessage ?? 'حدث خطأ في إضافة الأب الأسقف',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

