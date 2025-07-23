import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.light(),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.dark(),
  );
}
