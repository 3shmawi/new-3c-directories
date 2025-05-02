import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    primaryColor: Colors.blue[900],
    bottomNavigationBarTheme: _customBottomNavBarTheme,
  );

  static final dark = ThemeData(
    primaryColor: Colors.blue[900],
    bottomNavigationBarTheme: _customBottomNavBarTheme,
  );

  ///customs themes
  static final _customBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey[500],
    type: BottomNavigationBarType.fixed,
  );
}
