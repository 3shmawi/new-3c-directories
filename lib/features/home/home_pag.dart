import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePag extends StatelessWidget {
  const HomePag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}
