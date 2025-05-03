import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/theme.dart';
import 'package:new_3c/controller/theme_ctrl.dart';
import 'package:new_3c/screens/layout/view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCtrl(),
      child: BlocBuilder<ThemeCtrl, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: LayoutView(),
          );
        },
      ),
    );
  }
}
