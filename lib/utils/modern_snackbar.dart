import 'package:flutter/material.dart';

class ModernSnackBar {
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = _getColors(type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colors.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.borderColor, width: 1),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: duration,
        elevation: 6,
      ),
    );
  }

  static _SnackBarColors _getColors(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarColors(
          backgroundColor: const Color(0xFF4CAF50),
          borderColor: const Color(0xFF66BB6A),
        );
      case SnackBarType.error:
        return _SnackBarColors(
          backgroundColor: const Color(0xFFE53935),
          borderColor: const Color(0xFFEF5350),
        );
      case SnackBarType.warning:
        return _SnackBarColors(
          backgroundColor: const Color(0xFFFB8C00),
          borderColor: const Color(0xFFFFB74D),
        );
      case SnackBarType.info:
        return _SnackBarColors(
          backgroundColor: const Color(0xFF1E88E5),
          borderColor: const Color(0xFF42A5F5),
        );
    }
  }

  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }
}

enum SnackBarType { success, error, warning, info }

class _SnackBarColors {
  final Color backgroundColor;
  final Color borderColor;

  _SnackBarColors({required this.backgroundColor, required this.borderColor});
}
