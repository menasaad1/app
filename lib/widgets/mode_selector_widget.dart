import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_mode_provider.dart';
import '../providers/bishops_provider.dart';
import '../providers/priests_provider.dart';

class ModeSelectorWidget extends StatelessWidget {
  const ModeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModeProvider>(
      builder: (context, appModeProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bishops Mode
              GestureDetector(
                onTap: () async {
                  await appModeProvider.switchToBishops();
                  if (context.mounted) {
                    Provider.of<BishopsProvider>(context, listen: false).fetchBishops();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: appModeProvider.isBishopsMode
                        ? const Color(0xFF8B5CF6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.church,
                        size: 16,
                        color: appModeProvider.isBishopsMode
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الأساقفة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appModeProvider.isBishopsMode
                              ? Colors.white
                              : Colors.grey[600],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Priests Mode
              GestureDetector(
                onTap: () async {
                  await appModeProvider.switchToPriests();
                  if (context.mounted) {
                    Provider.of<PriestsProvider>(context, listen: false).fetchPriests();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: appModeProvider.isPriestsMode
                        ? const Color(0xFF3B82F6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: appModeProvider.isPriestsMode
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الكهنة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appModeProvider.isPriestsMode
                              ? Colors.white
                              : Colors.grey[600],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
