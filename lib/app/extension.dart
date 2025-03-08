import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  void push(Widget page) => Navigator.of(this).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  void pop() => Navigator.of(this).pop();

  void pushReplacementCurrent(Widget page) =>
      Navigator.of(this).pushReplacement(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  void pushReplacementAll(Widget page) => Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (_) => false,
      );
}
