import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/config/app_config.dart';
import 'package:new_3c/config/theme.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/views/auth/login_view.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: BlocProvider(
        create: (context) => AuthCtrl(),
        child: LoginView(),
      ),
    );
  }
}

///   Settings >>  Build number >> tap 7 times to enable developer mode
