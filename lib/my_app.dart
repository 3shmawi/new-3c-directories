import 'package:flutter/material.dart';
import 'package:new_3c/random_user/random_user_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RandomUserPage(),
    );
  }
}
