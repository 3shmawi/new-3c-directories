import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_3c/app/config.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/layout/view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int counter = 2;
  late Timer _timer;

  _initCounter() {
    _timer = Timer.periodic(
      Duration(seconds: counter),
      (_) => context.pushReplacement(LayoutView()),
    );
  }

  @override
  void initState() {
    _initCounter();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(AppConfig.logo),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        child: Text(
          AppConfig.appName,
          style: TextStyle(
            color: Colors.grey,
            backgroundColor: Colors.transparent,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
