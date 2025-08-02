import 'package:flutter/material.dart';
import 'package:new_3c/screens/splash_screen.dart';

class RovanApp extends StatelessWidget {
  const RovanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      )),
      home: SplashScreen(),
    );
  }
}
