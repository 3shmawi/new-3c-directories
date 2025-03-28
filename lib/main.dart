import 'package:flutter/material.dart';

// import 'package:new_3c/profile/ui.dart';

import 'countries/ui.dart';

// import 'dog_image/ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: GetDogImage(),
      // home: ProfileScreen(),
      home: CountriesView(),
    );
  }
}
