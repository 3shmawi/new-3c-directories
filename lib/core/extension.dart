import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(Widget screen) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void replaceWith(Widget screen) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void pop() {
    Navigator.pop(this);
  }
}

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
