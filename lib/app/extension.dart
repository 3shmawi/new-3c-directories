import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  toPage(Widget page) => Navigator.of(this).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  pushReplacement(Widget page) => Navigator.of(this).pushReplacement(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  back() => Navigator.of(this).pop();

  pushAndFinish(Widget page) => Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (route) => false,
      );
}
