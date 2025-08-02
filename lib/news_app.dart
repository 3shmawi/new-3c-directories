import 'package:flutter/material.dart';
import 'package:new_3c/core/theme.dart';
import 'package:new_3c/screens/splash_screen.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
