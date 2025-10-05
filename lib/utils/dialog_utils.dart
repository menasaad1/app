import 'package:flutter/material.dart';

class DialogUtils {
  static void showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color confirmColor = Colors.red,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              cancelText,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                fontFamily: 'Arial',
                color: confirmColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'موافق',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              buttonText,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ),
        ],
      ),
    );
  }
  
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'موافق',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              buttonText,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ),
        ],
      ),
    );
  }
  
  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'موافق',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              buttonText,
              style: const TextStyle(fontFamily: 'Arial'),
            ),
          ),
        ],
      ),
    );
  }
}
