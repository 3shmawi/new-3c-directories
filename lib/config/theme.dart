import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

//SOLId principle: Single Responsibility Principle (SRP)
abstract class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(AppConfig.primaryColor),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(AppConfig.primaryColor)),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: Color(AppConfig.primaryColor), width: 2.0),
      ),
      labelStyle: TextStyle(color: Color(AppConfig.primaryColor)),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      minWidth: double.infinity,
      height: 45,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(AppConfig.primaryColor),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        minimumSize: Size(double.infinity, 40),
      ),
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(AppConfig.primaryColor),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );
}
