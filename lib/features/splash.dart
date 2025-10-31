import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/features/auth/auth.dart';
import 'package:new_3c/features/home/home_pag.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePag();
            }
            if (!snapshot.hasData) {
              return const AuthPage();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
