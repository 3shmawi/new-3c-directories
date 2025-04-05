import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/auth/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home Screen',
              style: TextStyle(fontSize: 50),
            ),
            ElevatedButton(
              onPressed: () async {
                final isLoggedOut = await logout();
                if (isLoggedOut) {
                  context.pushAndRemoveUntil(LoginScreen());
                }
              },
              child: Text("LOGOUT"),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
