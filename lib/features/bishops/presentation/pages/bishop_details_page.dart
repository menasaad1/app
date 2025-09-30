import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/locale/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/bishop_provider.dart';

class BishopDetailsPage extends ConsumerWidget {
  final String bishopId;
  
  const BishopDetailsPage({
    super.key,
    required this.bishopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bishopAsync = ref.watch(bishopByIdProvider(bishopId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bishopDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/bishops/$bishopId/edit'),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: AppTheme.errorColor),
                    const SizedBox(width: 8),
                    Text(l10n.delete),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  context.go('/bishops/$bishopId/edit');
                  break;
                case 'delete':
                  _showDeleteDialog(context, l10n, ref);
                  break;
              }
            },
          ),
        ],
      ),
      body: bishopAsync.when(
        data: (bishop) {
          if (bishop == null) {
            return _buildNotFoundState(context, l10n);
          }
          return _buildBishopDetails(context, l10n, bishop);
        },
        loading: () => _buildLoadingState(context),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildBishopDetails(BuildContext context, AppLocalizations l10n, dynamic bishop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Photo and Basic Info
          _buildPhotoAndBasicInfo(context, l10n, bishop),
          
          const SizedBox(height: 24),
          
          // Contact Information
          _buildContactInfo(context, l10n, bishop),
          
          const SizedBox(height: 24),
          
          // Biography
          if (bishop.biography != null && bishop.biography.isNotEmpty)
            _buildBiography(context, l10n, bishop),
          
          const SizedBox(height: 24),
          
          // Additional Information
          _buildAdditionalInfo(context, l10n, bishop),
        ],
      ),
    );
  }

  Widget _buildPhotoAndBasicInfo(BuildContext context, AppLocalizations l10n, dynamic bishop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Photo
            Container(
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
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: bishop.photoUrl != null && bishop.photoUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: bishop.photoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildPhotoPlaceholder(),
                        errorWidget: (context, url, error) => _buildPhotoPlaceholder(),
                      )
                    : _buildPhotoPlaceholder(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Name and Title
            Text(
              bishop.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              bishop.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Diocese
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_city,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bishop.diocese,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
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

  Widget _buildContactInfo(BuildContext context, AppLocalizations l10n, dynamic bishop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الاتصال',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (bishop.phoneNumber != null && bishop.phoneNumber.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.phone,
                l10n.phoneNumber,
                bishop.phoneNumber,
                () => _makePhoneCall(bishop.phoneNumber),
              ),
            
            if (bishop.email != null && bishop.email.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.email,
                l10n.email,
                bishop.email,
                () => _sendEmail(bishop.email),
              ),
            
            if (bishop.address != null && bishop.address.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.location_on,
                l10n.address,
                bishop.address,
                null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
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

  Widget _buildBiography(BuildContext context, AppLocalizations l10n, dynamic bishop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.biography,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              bishop.biography,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, AppLocalizations l10n, dynamic bishop) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات إضافية',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDateInfo(
              context,
              Icons.calendar_today,
              l10n.ordinationDate,
              _formatDate(bishop.ordinationDate),
            ),
            
            const SizedBox(height: 16),
            
            _buildDateInfo(
              context,
              Icons.cake,
              l10n.birthDate,
              _formatDate(bishop.birthDate),
            ),
            
            const SizedBox(height: 16),
            
            _buildDateInfo(
              context,
              Icons.access_time,
              'تاريخ الإضافة',
              _formatDate(bishop.createdAt),
            ),
            
            const SizedBox(height: 16),
            
            _buildDateInfo(
              context,
              Icons.update,
              'آخر تحديث',
              _formatDate(bishop.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.secondaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل تفاصيل الأسقف...'),
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
            'حدث خطأ في تحميل تفاصيل الأسقف',
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
        ],
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'الأسقف غير موجود',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قد يكون تم حذف هذا الأسقف أو غير موجود',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/bishops'),
            child: const Text('العودة إلى قائمة الأساقفة'),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // TODO: Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم إضافة ميزة الاتصال قريباً: $phoneNumber'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _sendEmail(String email) {
    // TODO: Implement email functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم إضافة ميزة البريد الإلكتروني قريباً: $email'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBishop),
        content: const Text('هل أنت متأكد من حذف هذا الأسقف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(bishopActionsProvider.notifier).deleteBishop(bishopId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.bishopDeletedSuccessfully),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
                context.go('/bishops');
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
