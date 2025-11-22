import 'package:flutter/material.dart';

class EmptyChatList extends StatelessWidget {
  const EmptyChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list,
            size: 100,
            color: Colors.grey[400],
          ),
          Text(
            "Start write send a message",
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          )
        ],
      ),
    );
  }
}
