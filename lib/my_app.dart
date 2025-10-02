import 'package:flutter/material.dart';
import 'package:new_3c/display_simple_posts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DisplaySimplePosts(),
    );
  }
}
