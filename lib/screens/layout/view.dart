import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

import 'components/bottom_nav_bar.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCtrl, LayoutStates>(
      builder: (context, state) {
        final ctrl = LayoutCtrl.get(context);
        return Scaffold(
          body: ctrl.screens[ctrl.currentIndex],
          bottomNavigationBar: BottomNavBarItem(ctrl),
        );
      },
    );
  }
}
