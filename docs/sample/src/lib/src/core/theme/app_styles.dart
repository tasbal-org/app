import 'package:flutter/material.dart';
import 'package:qrino_admin/src/core/theme/app_colors.dart';

class AppStyles {
  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textSecondary),
      );
}