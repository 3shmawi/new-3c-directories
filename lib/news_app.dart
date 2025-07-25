import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/config/app_config.dart';
import 'package:new_3c/config/theme.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/controller/theme_ctrl.dart';
import 'package:new_3c/services/local_storage.dart';
import 'package:new_3c/views/auth/login_view.dart';
import 'package:new_3c/views/layout/layout_view.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCtrl>(
          create: (context) => AuthCtrl(),
        ),
        BlocProvider<ThemeCtrl>(
          create: (context) => ThemeCtrl(),
        ),
      ],
      child: BlocBuilder<ThemeCtrl, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            title: AppConfig.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: FutureBuilder(
              future: _getInitView(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return Scaffold(
                  body: Center(
                    child: Text('No data found'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<Widget> _getInitView() async {
    final box = await HiveService().openBox("myUserData");
    final userData = box.get("myData");

    if (userData == null) {
      return LoginView();
    } else {
      return LayoutView();
    }
  }
}

///   Settings >>  Build number >> tap 7 times to enable developer mode
