import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final bool isLoading;
  final Widget? icon;
  final double? elevation;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.icon,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? AppConstants.buttonHeightMedium,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
          foregroundColor: textColor ?? AppColors.buttonText,
          elevation: elevation ?? AppConstants.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppConstants.radiusXLarge,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
                width: MediaQuery.of(context).size.height * 0.025,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.buttonText,
                  ),
                ),
              )
            : icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: textColor ?? AppColors.buttonText,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: AppTextStyles.buttonLarge.copyWith(
                  color: textColor ?? AppColors.buttonText,
                ),
              ),
      ),
    );
  }
}

