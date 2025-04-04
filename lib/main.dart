import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/countries/cubit.dart';
import 'package:new_3c/theme/theme_cubit.dart';

// import 'package:new_3c/profile/ui.dart';

import 'countries/ui.dart';

// import 'dog_image/ui.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          // home: GetDogImage(),
          // home: ProfileScreen(),
          home: BlocProvider(
            create: (context) => CountriesCubit()..getCountries(),
            child: CountriesView(),
          ),
        );
      },
    );
  }
}
