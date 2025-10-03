import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/firebase_options.dart';
import 'package:new_3c/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
