import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl/layout_cubit.dart';
import 'package:new_3c/controller/settings_ctrl/settings_cubit.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';
import 'package:new_3c/screens/auth/login.dart';
import 'package:new_3c/screens/layout.dart';
import 'package:new_3c/services/local_storage.dart';

import 'firebase_options.dart';

///Authentication
// [login - register - logout]

///FireStore
// [GET - UPDATE - DELETE - SET - ADD - STREAM]
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LayoutCubit(),
        ),
        BlocProvider(
          create: (_) => UserCubit()..getMyUserData(),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myId = CacheHelper.getData(key: "myId");
    return BlocBuilder<SettingsCubit, SettingsStates>(
      buildWhen: (_, current) => current is ChangeThemeState,
      builder: (context, state) {
        final isDark = SettingsCubit.get(context).isDark;
        return MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: myId == null ? LoginScreen() : LayoutScreen(),
        );
      },
    );
  }
}
