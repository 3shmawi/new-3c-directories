import 'package:flutter/material.dart';

class AppBarPart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPart({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text.rich(
        TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "Jana",
              style: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
            TextSpan(
              text: "News",
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
