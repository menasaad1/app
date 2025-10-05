import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/priest.dart';
import '../utils/app_colors.dart';

class PriestCard extends StatelessWidget {
  final Priest priest;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PriestCard({
    super.key,
    required this.priest,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shadowColor: AppColors.cardPriest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              AppColors.cardPriest.withValues(alpha: 0.05),
              AppColors.cardPriest.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardPriest.withValues(alpha: 0.15),
                blurRadius: 20.0,
                offset: const Offset(0.0, 8.0),
              ),
              BoxShadow(
                color: AppColors.cardPriest.withValues(alpha: 0.05),
                blurRadius: 8.0,
                offset: const Offset(0.0, 2.0),
              ),
            ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getCardGradient('priest'),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardPriest.withValues(alpha: 0.3),
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (priest.rank != null) ...[
                              Text(
                                priest.rank!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                priest.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                color: AppColors.cardPriest,
                                fontFamily: 'Cairo',
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    blurRadius: 1.0,
                                    offset: const Offset(0.0, 1.0),
                                  ),
                                ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (priest.church != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            priest.church!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isAdmin) ...[
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue, size: 20),
                              SizedBox(width: 8),
                              Text('تعديل', style: TextStyle(fontFamily: 'Cairo')),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('حذف', style: TextStyle(fontFamily: 'Cairo')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cardPriest.withValues(alpha: 0.1),
                      AppColors.cardPriest.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.cardPriest.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardPriest.withValues(alpha: 0.1),
                      blurRadius: 6.0,
                      offset: const Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.cardPriest,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تاريخ الرسامة: ${DateFormat('yyyy/MM/dd', 'ar').format(priest.ordinationDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.cardPriest,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (priest.notes != null && priest.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملاحظات:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        priest.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[900],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
