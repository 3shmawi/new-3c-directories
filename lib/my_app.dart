import 'package:flutter/material.dart';
import 'package:new_3c/screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // home: DisplayDogImage(),
      // home: DisplayUserProfile(),
      home: HomeScreen(),
    );
  }
}
