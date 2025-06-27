import 'package:flutter/material.dart';

import 'app_config.dart';

//SOLId principle: Single Responsibility Principle (SRP)
abstract class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(AppConfig.primaryColor),
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(AppConfig.primaryColor),
    ),
  );
}
