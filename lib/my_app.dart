import 'package:flutter/material.dart';

import 'dog_api/dog_api_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DogApiPage(),
    );
  }
}
