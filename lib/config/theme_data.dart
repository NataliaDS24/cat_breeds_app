import 'package:flutter/material.dart';
import 'package:cat_breeds_app/config/config_imports.dart';

class ThemeDataApp {
  static ThemeData themeData = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.background,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
    ),
    scaffoldBackgroundColor: AppColors.background,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    useMaterial3: true,
  );
}
