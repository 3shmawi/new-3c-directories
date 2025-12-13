import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/theme_ctrl.dart';

import 'display_simple_posts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeStates>(
        builder: (context, isDark) {
          final cubit = context.read<ThemeCubit>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: Display(),
          );
        },
      ),
    );
  }
}
