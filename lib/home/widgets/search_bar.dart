import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        spacing: 5,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
          Text(
            "Search...",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
