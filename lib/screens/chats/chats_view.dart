import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Chats Screen',
          style: TextStyle(
            fontSize: 50,
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to the chat screen',
          style: TextStyle(
            fontSize: 25,
            color: Colors.cyan,
          ),
        ),
      ],
    );
  }
}
