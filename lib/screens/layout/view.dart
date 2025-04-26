import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';
import 'package:new_3c/screens/layout/components/body.dart';
import 'package:new_3c/screens/layout/components/bottom_nav_bar.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCtrl(),
      child: Scaffold(
        body: LayoutBody(),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
