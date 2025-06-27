import 'package:flutter/material.dart';
import 'package:new_3c/config/app_config.dart';
import 'package:new_3c/config/theme.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
