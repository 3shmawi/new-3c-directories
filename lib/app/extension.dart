import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void navigateTo(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void navigateAndReplace(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void navigateAndFinish(Widget page) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  void navigateBack() {
    Navigator.pop(this);
  }
}
