import 'package:flutter/material.dart';
import 'package:cat_breeds_app/config/config_imports.dart';

class ThemeDataApp {
  static ThemeData themeData = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
    ),
    scaffoldBackgroundColor: AppColors.white,
    useMaterial3: true,
  );
}
