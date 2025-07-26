import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCtrl(),
      child: BlocBuilder<LayoutCtrl, LayoutStates>(
        builder: (context, state) {
          final ctrl = context.read<LayoutCtrl>();
          return Scaffold(
            body: ctrl.screens[ctrl.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: ctrl.currentIndex,
              onTap: ctrl.changeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
