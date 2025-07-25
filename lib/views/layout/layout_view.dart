import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCtrl(),
      child: BlocBuilder<LayoutCtrl, LayoutStates>(
        builder: (context, state) {
          final layoutCtrl = LayoutCtrl.get(context);
          return Scaffold(
            body: layoutCtrl.views[layoutCtrl.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: layoutCtrl.currentIndex,
              onTap: layoutCtrl.changeBottomNav,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.feed_outlined),
                  label: 'Feeds',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.add_comment_outlined),
                  label: 'New Feed',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
