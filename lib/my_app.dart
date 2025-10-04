import 'package:flutter/material.dart';
import 'package:new_3c/screens/display_dog_imge.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayDogImage(),
    );
  }
}
