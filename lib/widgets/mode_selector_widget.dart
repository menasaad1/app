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
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[400]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'اختر وضع التطبيق',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   // Bishops Mode
                   Expanded(
                     child: GestureDetector(
                       onTap: () async {
                         await appModeProvider.switchToBishops();
                         // Reload data for bishops
                         if (context.mounted) {
                           Provider.of<BishopsProvider>(context, listen: false).fetchBishops();
                         }
                       },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appModeProvider.isBishopsMode
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appModeProvider.isBishopsMode
                                ? Colors.deepPurple
                                : Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.church,
                              size: 32,
                              color: appModeProvider.isBishopsMode
                                  ? Colors.deepPurple
                                  : Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'الآباء الأساقفة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appModeProvider.isBishopsMode
                                    ? Colors.deepPurple
                                    : Colors.white,
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'إدارة وترتيب الأساقفة',
                              style: TextStyle(
                                fontSize: 12,
                                color: appModeProvider.isBishopsMode
                                    ? Colors.deepPurple[600]
                                    : Colors.white70,
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                   // Priests Mode
                   Expanded(
                     child: GestureDetector(
                       onTap: () async {
                         await appModeProvider.switchToPriests();
                         // Reload data for priests
                         if (context.mounted) {
                           Provider.of<PriestsProvider>(context, listen: false).fetchPriests();
                         }
                       },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appModeProvider.isPriestsMode
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appModeProvider.isPriestsMode
                                ? Colors.blue
                                : Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person,
                              size: 32,
                              color: appModeProvider.isPriestsMode
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'الآباء الكهنة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appModeProvider.isPriestsMode
                                    ? Colors.blue
                                    : Colors.white,
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'إدارة وترتيب الكهنة',
                              style: TextStyle(
                                fontSize: 12,
                                color: appModeProvider.isPriestsMode
                                    ? Colors.blue[600]
                                    : Colors.white70,
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
