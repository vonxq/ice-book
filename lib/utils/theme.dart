import 'package:flutter/material.dart';

class AppTheme {
  // 晨曦紫主题
  static const Color dawnPurplePrimary = Color(0xFF8B5CF6);
  static const Color dawnPurpleIncome = Color(0xFFF59E0B);
  static const Color dawnPurpleExpense = Color(0xFFEF4444);

  // 海洋蓝主题
  static const Color oceanBluePrimary = Color(0xFF3B82F6);
  static const Color oceanBlueIncome = Color(0xFF10B981);
  static const Color oceanBlueExpense = Color(0xFFF87171);

  // 森林绿主题
  static const Color forestGreenPrimary = Color(0xFF059669);
  static const Color forestGreenIncome = Color(0xFFF59E0B);
  static const Color forestGreenExpense = Color(0xFFDC2626);

  // 日落橙主题
  static const Color sunsetOrangePrimary = Color(0xFFEA580C);
  static const Color sunsetOrangeIncome = Color(0xFF16A34A);
  static const Color sunsetOrangeExpense = Color(0xFFDC2626);

  // 极简灰主题
  static const Color minimalGrayPrimary = Color(0xFF6B7280);
  static const Color minimalGrayIncome = Color(0xFF10B981);
  static const Color minimalGrayExpense = Color(0xFFEF4444);

  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme.fromSeed(
        seedColor: dawnPurplePrimary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme.fromSeed(
        seedColor: dawnPurplePrimary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF1F2937),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // 获取主题颜色
  static Color getPrimaryColor(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return dawnPurplePrimary;
      case ThemeMode.dark:
        return dawnPurplePrimary;
      default:
        return dawnPurplePrimary;
    }
  }

  static Color getIncomeColor(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return dawnPurpleIncome;
      case ThemeMode.dark:
        return dawnPurpleIncome;
      default:
        return dawnPurpleIncome;
    }
  }

  static Color getExpenseColor(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return dawnPurpleExpense;
      case ThemeMode.dark:
        return dawnPurpleExpense;
      default:
        return dawnPurpleExpense;
    }
  }
} 