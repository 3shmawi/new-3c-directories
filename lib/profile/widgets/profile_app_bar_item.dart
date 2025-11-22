import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAppBarItem extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.settings))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}
