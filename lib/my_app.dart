import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/theme.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/controller/theme_ctrl.dart';
import 'package:new_3c/screens/auth/login_view.dart';
import 'package:new_3c/screens/layout/view.dart';
import 'package:new_3c/services/local_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCtrl()),
        BlocProvider(create: (context) => AuthCtrl()..getMyData()),
      ],
      child: BlocBuilder<ThemeCtrl, bool>(
        builder: (context, isDark) {
          final authorId = CacheHelper.getData(key: "authorId");
          return MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: authorId == null ? LoginView() : LayoutView(),
          );
        },
      ),
    );
  }
}
