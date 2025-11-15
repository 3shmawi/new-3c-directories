import 'package:flutter/material.dart';

import 'intro/screens/display_user_profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: DisplayDogImage(),
      home: DisplayUserProfile(),
    );
  }
}
