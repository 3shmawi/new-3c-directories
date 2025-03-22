import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/auth/login.dart';

import 'firebase_options.dart';

///Authentication
// [login - register - logout]

///FireStore
// [GET - UPDATE - DELETE - SET - ADD - STREAM]
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}
