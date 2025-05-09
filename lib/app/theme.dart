import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    primaryColor: Colors.blue[900],
    bottomNavigationBarTheme: _customBottomNavBarTheme,
    inputDecorationTheme: _customInputDecorationTheme,
    elevatedButtonTheme: _customElevatedButtonTheme,
  );

  static final dark = ThemeData(
    primaryColor: Colors.blue[900],
    bottomNavigationBarTheme: _customBottomNavBarTheme,
    inputDecorationTheme: _customInputDecorationTheme,
    elevatedButtonTheme: _customElevatedButtonTheme,
  );

  ///customs themes
  static final _customBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey[500],
    type: BottomNavigationBarType.fixed,
  );

  static final _customInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey[300]!,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.blue[900]!,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey[300]!,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.red[900]!,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 20,
    ),
  );

  static final _customElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 45),
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
