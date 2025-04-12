import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_3c/cubit/news.dart';
import 'package:new_3c/cubit/theme.dart';
import 'package:new_3c/screens/home.dart';

import 'model/news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArticlesAdapter());
  await Hive.openBox<Articles>('news1');
  final box = await Hive.openBox<bool>('theme');
  final isDark = box.get('isDark', defaultValue: false) as bool;
  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget {
  const MyApp(this.isDark, {super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(isDark),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: BlocProvider(
              create: (context) => NewsCubit()..getNewsDataFromHive(),
              child: NewsHomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
