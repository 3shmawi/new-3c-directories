import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem(this.ctrl, {super.key});

  final LayoutCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: ctrl.currentIndex,
      onTap: ctrl.changeBottomNavBar,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.news),
          label: "Newsletter",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add_circled),
          label: "New Article",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          label: "Profile",
        ),
      ],
    );
  }
}
