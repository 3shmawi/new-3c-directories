import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
}
