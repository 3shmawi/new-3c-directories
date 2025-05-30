import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/theme.dart';
import 'package:new_3c/controller/article_ctrl.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/profile/view.dart';

import 'controller/layout_ctrl.dart';
import 'screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCtrl()),
        BlocProvider<AuthCtrl>(
          create: (context) => AuthCtrl()..getMyData(),
        ),
        BlocProvider<ArticleCtrl>(
          create: (context) => ArticleCtrl()..getArticles(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthCtrl()..getMyData(),
        child: ValueListenableBuilder(
            valueListenable: isDark,
            builder: (_, value, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: value ? ThemeMode.dark : ThemeMode.light,
                home: SplashScreen(),
              );
            }),
      ),
    );
  }
}
