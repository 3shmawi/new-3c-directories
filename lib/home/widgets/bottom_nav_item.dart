import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.group),
          label: "Users",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.square_stack_3d_down_right),
          label: "Stories",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
