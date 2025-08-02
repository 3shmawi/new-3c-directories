import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/screens/layout/users/users_screen.dart';

import '../screens/layout/home/home_screen.dart';
import '../screens/layout/profile/profile_screen.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitialState());

  static LayoutCtrl get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(LayoutChangeIndexState(index));
  }
}

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class LayoutChangeIndexState extends LayoutStates {
  final int index;

  LayoutChangeIndexState(this.index);
}
