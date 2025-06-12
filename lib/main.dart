import 'package:flutter/material.dart';
import 'package:new_3c/views/dog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DisplayDogImageFromApi(),
    );
  }
}
