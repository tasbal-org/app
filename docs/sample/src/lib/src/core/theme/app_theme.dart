import 'package:flutter/material.dart';
import 'package:qrino_admin/src/core/theme/app_colors.dart';
import 'package:qrino_admin/src/core/theme/app_typography.dart';
import 'package:qrino_admin/src/core/theme/app_styles.dart';

class AppTheme {
  static ThemeData get themeData => ThemeData(
        // カラー
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        useMaterial3: true,

        // テキスト
        textTheme: AppTypography.textTheme,

        // ボタン
        elevatedButtonTheme: AppStyles.elevatedButtonTheme,
        textButtonTheme: AppStyles.textButtonTheme,
        outlinedButtonTheme: AppStyles.outlinedButtonTheme,

        // 入力フォーム
        inputDecorationTheme: AppStyles.inputDecorationTheme,

        // アプリバー
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          titleTextStyle: AppTypography.textTheme.headlineSmall,
        ),

        // カード
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // ダイアログ
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // アイコン
        iconTheme: IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
      );

  static ThemeData getTheme() => themeData;
}