import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/bishop_provider.dart';
import '../../domain/entities/bishop.dart';

class AddEditBishopPage extends ConsumerStatefulWidget {
  final String? bishopId;
  
  const AddEditBishopPage({super.key, this.bishopId});

  @override
  ConsumerState<AddEditBishopPage> createState() => _AddEditBishopPageState();
}

class _AddEditBishopPageState extends ConsumerState<AddEditBishopPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _dioceseController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _biographyController = TextEditingController();
  
  DateTime? _ordinationDate;
  DateTime? _birthDate;
  String? _photoUrl;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.bishopId != null) {
      _loadBishopData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _dioceseController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  Future<void> _loadBishopData() async {
    final bishopAsync = ref.read(bishopByIdProvider(widget.bishopId!));
    bishopAsync.when(
      data: (bishop) {
        if (bishop != null) {
          _nameController.text = bishop.name;
          _titleController.text = bishop.title;
          _dioceseController.text = bishop.diocese;
          _phoneController.text = bishop.phoneNumber ?? '';
          _emailController.text = bishop.email ?? '';
          _addressController.text = bishop.address ?? '';
          _biographyController.text = bishop.biography ?? '';
          _ordinationDate = bishop.ordinationDate;
          _birthDate = bishop.birthDate;
          _photoUrl = bishop.photoUrl;
        }
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.bishopId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.editBishop : l10n.addBishop),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Section
              _buildPhotoSection(context, l10n),
              
              const SizedBox(height: 24),
              
              // Basic Information
              _buildSectionHeader(context, 'المعلومات الأساسية'),
              const SizedBox(height: 16),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.bishopName,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.requiredField;
                  }
                  if (value.length < 2) {
                    return l10n.nameTooShort;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.bishopTitle,
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.requiredField;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Diocese Field
              TextFormField(
                controller: _dioceseController,
                decoration: InputDecoration(
                  labelText: l10n.diocese,
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.requiredField;
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Dates Section
              _buildSectionHeader(context, 'التواريخ المهمة'),
              const SizedBox(height: 16),
              
              // Ordination Date
              _buildDateField(
                context,
                l10n.ordinationDate,
                _ordinationDate,
                Icons.calendar_today,
                _selectOrdinationDate,
              ),
              
              const SizedBox(height: 16),
              
              // Birth Date
              _buildDateField(
                context,
                l10n.birthDate,
                _birthDate,
                Icons.cake,
                _selectBirthDate,
              ),
              
              const SizedBox(height: 24),
              
              // Contact Information
              _buildSectionHeader(context, 'معلومات الاتصال'),
              const SizedBox(height: 16),
              
              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                      return l10n.invalidPhone;
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return l10n.invalidEmail;
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.address,
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Biography Section
              _buildSectionHeader(context, 'السيرة الذاتية'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _biographyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.biography,
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBishop,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isEdit ? l10n.save : l10n.add,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          // Photo Display
          GestureDetector(
            onTap: _selectPhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : _photoUrl != null && _photoUrl!.isNotEmpty
                        ? Image.network(
                            _photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPhotoPlaceholder(),
                          )
                        : _buildPhotoPlaceholder(),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Photo Action Button
          ElevatedButton.icon(
            onPressed: _selectPhoto,
            icon: const Icon(Icons.camera_alt),
            label: Text(l10n.selectPhoto),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? date,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null ? _formatDate(date) : label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: date != null ? AppTheme.textPrimaryColor : AppTheme.textHintColor,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    if (label == l10n.ordinationDate) {
                      _ordinationDate = null;
                    } else {
                      _birthDate = null;
                    }
                  });
                },
                icon: const Icon(Icons.clear, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  Future<void> _selectOrdinationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _ordinationDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _ordinationDate = date;
      });
    }
  }

  Future<void> _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _birthDate = date;
      });
    }
  }

  Future<void> _saveBishop() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_ordinationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requiredField),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requiredField),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final currentUser = ref.read(currentUserProvider);
      
      String? photoUrl = _photoUrl;
      if (_selectedImage != null) {
        photoUrl = await ref.read(bishopActionsProvider.notifier)
            .uploadPhoto(widget.bishopId ?? '', _selectedImage!.path);
      }

      final bishop = Bishop(
        id: widget.bishopId ?? '',
        name: _nameController.text.trim(),
        title: _titleController.text.trim(),
        diocese: _dioceseController.text.trim(),
        ordinationDate: _ordinationDate!,
        birthDate: _birthDate!,
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        biography: _biographyController.text.trim().isEmpty ? null : _biographyController.text.trim(),
        photoUrl: photoUrl,
        createdAt: widget.bishopId != null ? now : now, // This should be loaded from existing data
        updatedAt: now,
        createdBy: currentUser?.uid ?? 'unknown',
        updatedBy: currentUser?.uid ?? 'unknown',
      );

      if (widget.bishopId != null) {
        await ref.read(bishopActionsProvider.notifier).updateBishop(bishop);
      } else {
        await ref.read(bishopActionsProvider.notifier).addBishop(bishop);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.bishopId != null
                  ? l10n.bishopUpdatedSuccessfully
                  : l10n.bishopAddedSuccessfully,
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.bishopId != null
                  ? l10n.failedToUpdateBishop
                  : l10n.failedToAddBishop,
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
