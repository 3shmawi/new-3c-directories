import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/state_management/counter/controller.dart';
import 'package:new_3c/state_management/counter/ui.dart';
import 'package:new_3c/state_management/theme/controller.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ThemeController(),
      child: BlocBuilder<ThemeController, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: BlocProvider(
              create: (context) => CounterCubit(),
              child: CounterExample(),
            ),
          );
        },
      ),
    ),
  );
}
