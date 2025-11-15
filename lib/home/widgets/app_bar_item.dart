import 'package:flutter/material.dart';

final isLocalized = ValueNotifier(false);

class AppBarItem extends StatelessWidget implements PreferredSizeWidget {
  const AppBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Messenger",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            isLocalized.value = !isLocalized.value;
          },
          icon: Icon(
            Icons.translate,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}
