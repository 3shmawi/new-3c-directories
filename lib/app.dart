import 'package:flutter/material.dart';
import 'package:new_3c/layout/layout_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutView(),
    );
  }
}
