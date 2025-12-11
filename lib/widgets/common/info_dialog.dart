import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onOkPressed;
  final IconData icon;
  final Color iconColor;

  const InfoDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onOkPressed,
    this.icon = Icons.info,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 60),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onOkPressed != null) {
                    onOkPressed!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static method to show the dialog easily
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onOkPressed,
    IconData icon = Icons.info,
    Color iconColor = Colors.blue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        onOkPressed: onOkPressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}
