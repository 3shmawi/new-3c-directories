import 'package:flutter/material.dart';
import 'package:new_3c/home/home_screen.dart';
import 'package:new_3c/home/widgets/home_app_bar_item.dart';
import 'package:new_3c/layout/widgets/bottom_nav_item.dart';
import 'package:new_3c/stories/stories_screen.dart';
import 'package:new_3c/users/users_screen.dart';

import '../profile/profile_screen.dart';
import '../profile/widgets/profile_app_bar_item.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  //logic
  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    UsersScreen(),
    StoriesScreen(),
    ProfileScreen(),
  ];

  final List<PreferredSizeWidget> appbars = [
    HomeAppBarItem(),
    HomeAppBarItem(),
    HomeAppBarItem(),
    ProfileAppBarItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: currentIndex == 3 ? true : false,
      extendBodyBehindAppBar: currentIndex == 3 ? true : false,
      appBar: appbars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavItem(
        index: currentIndex,
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
