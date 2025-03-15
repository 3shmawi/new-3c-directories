import 'package:flutter/material.dart';
import 'package:new_3c/app/theme.dart';
import 'package:new_3c/controller/auth.dart';
import 'package:new_3c/screens/auth/login.dart';
import 'package:new_3c/screens/chats/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeManager.light,
      darkTheme: ThemeManager.dark,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: AuthCubit.myId == "unauthorized" ? LoginPage() : ChatsScreen(),
    );
  }
}
