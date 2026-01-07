// core/theme/typography.dart
import 'package:flutter/material.dart';
import 'package:qrino_admin/src/core/theme/app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Roboto'; // Google Fonts など

  static TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
          fontFamily: fontFamily,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: fontFamily,
        ),
      );
}