import 'package:flutter/material.dart';
import '../models/bishop.dart';
import '../models/priest.dart';
import '../utils/app_colors.dart';

class SelectionItemWidget extends StatelessWidget {
  final dynamic item; // Bishop or Priest
  final bool isSelected;
  final VoidCallback onTap;
  final bool isBishop;

  const SelectionItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.isBishop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isBishop 
                    ? AppColors.cardBishop.withValues(alpha: 0.1)
                    : AppColors.cardPriest.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isBishop ? Icons.account_balance : Icons.church,
                color: isBishop ? AppColors.cardBishop : AppColors.cardPriest,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Diocese/Church
                  Text(
                    isBishop 
                        ? (item as Bishop).diocese ?? 'غير محدد'
                        : (item as Priest).church ?? 'غير محدد',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Additional info
                  if (isBishop) ...[
                    const SizedBox(height: 4),
                    Text(
                      'تاريخ الرسامة: ${_formatDate((item as Bishop).ordinationDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if ((item as Priest).rank != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.cardPriest.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (item as Priest).rank!,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.cardPriest,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          'تاريخ الرسامة: ${_formatDate((item as Priest).ordinationDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}';
  }
}
