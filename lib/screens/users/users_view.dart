import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Users Screen',
          style: TextStyle(
            fontSize: 50,
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to the users screen',
          style: TextStyle(
            fontSize: 25,
            color: Colors.cyan,
          ),
        ),
      ],
    );
  }
}
