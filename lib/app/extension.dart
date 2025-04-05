import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void showError(String txt) => ScaffoldMessenger.of(this).showSnackBar(
        _snackBar(txt, Colors.red),
      );

  void showSuccess(String txt) => ScaffoldMessenger.of(this).showSnackBar(
        _snackBar(txt, Colors.green),
      );

  void push(Widget page) => Navigator.of(this).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  void pushReplacement(Widget page) => Navigator.of(this).pushReplacement(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  void pushAndRemoveUntil(Widget page) => Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (route) => false,
      );

  void pop() => Navigator.of(this).pop();

  SnackBar _snackBar(txt, color) => SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        backgroundColor: color,
        content: Text(txt),
      );
}
