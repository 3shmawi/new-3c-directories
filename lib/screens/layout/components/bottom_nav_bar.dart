import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(this.ctrl, {super.key});

  final LayoutCtrl ctrl;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: ctrl.currentIndex,
      onTap: ctrl.changeIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add_circled),
          label: "New Post",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          label: "Profile",
        ),
      ],
    );
  }
}
