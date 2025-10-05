import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/priest.dart';
import '../utils/app_colors.dart';

class PriestCard extends StatelessWidget {
  final Priest priest;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int? index;

  const PriestCard({
    super.key,
    required this.priest,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 4,
      shadowColor: AppColors.cardPriest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundCard,
              AppColors.cardPriest.withValues(alpha: 0.01),
              AppColors.cardPriest.withValues(alpha: 0.005),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardPriest.withValues(alpha: 0.03),
                blurRadius: 6.0,
                offset: const Offset(0.0, 1.0),
              ),
              BoxShadow(
                color: AppColors.cardPriest.withValues(alpha: 0.01),
                blurRadius: 3.0,
                offset: const Offset(0.0, 0.5),
              ),
            ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (index != null) ...[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.cardPriest,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardPriest.withValues(alpha: 0.3),
                            blurRadius: 4.0,
                            offset: const Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index! + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getCardGradient('priest'),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardPriest.withValues(alpha: 0.2),
                          blurRadius: 6.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cardPriest,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                priest.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                color: AppColors.cardPriest,
                                fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (priest.church != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            priest.church!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cardPriest.withValues(alpha: 0.03),
                      AppColors.cardPriest.withValues(alpha: 0.01),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.cardPriest.withValues(alpha: 0.05),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardPriest.withValues(alpha: 0.02),
                      blurRadius: 1.0,
                      offset: const Offset(0.0, 0.5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.cardPriest,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'تاريخ الرسامة: ${DateFormat('yyyy/MM/dd', 'ar').format(priest.ordinationDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.cardPriest,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (priest.notes != null && priest.notes!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملاحظات:',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        priest.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
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
