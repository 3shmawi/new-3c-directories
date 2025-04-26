import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

class LayoutBody extends StatelessWidget {
  const LayoutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCtrl, LayoutStates>(
      builder: (context, state) {
        final ctrl = LayoutCtrl.get(context);
        return ctrl.screens[ctrl.currentIndex];
      },
    );
  }
}
