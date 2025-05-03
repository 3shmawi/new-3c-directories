import 'package:flutter/material.dart';
import 'package:new_3c/app/colors.dart';

abstract class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColors.primary,
    brightness: Brightness.light,
    inputDecorationTheme: _inputDecorationTheme,
    elevatedButtonTheme: _elevationButtonTheme,
    bottomNavigationBarTheme: _bottomNavBarTheme,
  );

  static final dark = ThemeData(
    primaryColor: AppColors.primary,
    brightness: Brightness.dark,
    inputDecorationTheme: _inputDecorationTheme,
    elevatedButtonTheme: _elevationButtonTheme,
    bottomNavigationBarTheme: _bottomNavBarTheme,
  );

  ///components
  static final _inputDecorationTheme = InputDecorationTheme(
    labelStyle: const TextStyle(
      fontSize: 16,
    ),
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary, width: 1),
    ),
  );

  static final _elevationButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: Size(double.infinity, 45),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  );

  static final _bottomNavBarTheme = BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey[400],
    selectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
