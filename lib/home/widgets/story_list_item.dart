import 'package:flutter/material.dart';
import 'package:new_3c/home/widgets/avatar.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({required this.name, required this.image, super.key});

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Avatar(image),
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
