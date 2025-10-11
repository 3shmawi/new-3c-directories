import 'package:flutter/material.dart';

import 'avatar.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({
    required this.name,
    required this.message,
    required this.img,
    required this.time,
    super.key,
  });

  final String img;
  final String name;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Avatar(
            img,
            size: Size.square(60),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
