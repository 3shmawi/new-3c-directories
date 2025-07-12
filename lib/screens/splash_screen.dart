import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        title: Text(
          "Splash Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.cyan[900],
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.add_a_photo),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              // Action for the button
            },
          ),
          IconButton(
            onPressed: () {
              print('Notification button pressed');
            },
            icon: Icon(
              Icons.notification_add,
            ),
          ),
        ],
      ),
    );
  }
}
