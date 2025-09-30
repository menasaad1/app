import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../domain/entities/bishop.dart';

class BishopCard extends StatelessWidget {
  final Bishop bishop;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BishopCard({
    super.key,
    required this.bishop,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Bishop Photo
              _buildBishopPhoto(context),
              
              const SizedBox(width: 16),
              
              // Bishop Info
              Expanded(
                child: _buildBishopInfo(context),
              ),
              
              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBishopPhoto(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: bishop.photoUrl != null && bishop.photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: bishop.photoUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPhotoPlaceholder(),
                errorWidget: (context, url, error) => _buildPhotoPlaceholder(),
              )
            : _buildPhotoPlaceholder(),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Icon(
        Icons.person,
        color: AppTheme.primaryColor,
        size: 30,
      ),
    );
  }

  Widget _buildBishopInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bishop Name
        Text(
          bishop.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Bishop Title
        Text(
          bishop.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Diocese
        Row(
          children: [
            Icon(
              Icons.location_city,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                bishop.diocese,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Ordination Date
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              _formatDate(bishop.ordinationDate),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit Button
        IconButton(
          onPressed: onEdit,
          icon: Icon(
            Icons.edit,
            color: AppTheme.secondaryColor,
            size: 20,
          ),
          tooltip: 'تعديل',
        ),
        
        // Delete Button
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: AppTheme.errorColor,
            size: 20,
          ),
          tooltip: 'حذف',
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
