import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.cyan,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      prefixIconColor: Colors.cyan,
      hintStyle: TextStyle(
        color: Colors.cyan.withOpacity(0.6),
        fontSize: 14.0,
      ),
      labelStyle: TextStyle(color: Colors.cyan),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          minimumSize: Size(double.infinity, 40)),
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.cyan,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      prefixIconColor: Colors.cyan,
      hintStyle: TextStyle(
        color: Colors.cyan.withOpacity(0.6),
        fontSize: 14.0,
      ),
      labelStyle: TextStyle(color: Colors.cyan),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        minimumSize: Size(double.infinity, 40),
      ),
    ),
  );
}
