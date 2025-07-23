import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_3c/screens/layout/layout_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //logic will be here
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      // Navigate to the next screen after 2 seconds
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LayoutScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello World!"),
      ),
    );
  }
}
