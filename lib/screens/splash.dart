import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/screens/auth/login.dart';

import 'layout/layout_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Spacer(),
                  Icon(
                    Icons.flutter_dash,
                    size: 100,
                    color: Colors.cyan,
                  ),
                  Spacer(),
                  Text(
                    "Welcome to the Counter App",
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return LayoutScreen();
        }
        return LoginScreen();
      },
    );
  }
}
