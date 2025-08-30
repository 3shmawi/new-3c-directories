import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 150,
          color: Colors.red,
        ),
        const Text(
          "An error occurred",
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ],
    );
  }
}
