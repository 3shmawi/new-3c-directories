import 'package:flutter/material.dart';
import 'package:new_3c/app/theme.dart';
import 'package:new_3c/screens/profile/view.dart';

import 'screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isDark,
        builder: (_, value, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: value ? ThemeMode.dark : ThemeMode.light,
            home: SplashScreen(),
          );
        });
  }
}
