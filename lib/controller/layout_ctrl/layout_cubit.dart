import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/screens/chats/chats_view.dart';
import 'package:new_3c/screens/settings/settings_view.dart';
import 'package:new_3c/screens/users/users_view.dart';

LayoutCubit layoutCubit(context) => BlocProvider.of<LayoutCubit>(context);

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  int currentIndex = 0;
  final pageCtrl = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void changeLayout(int index) {
    currentIndex = index;
    pageCtrl.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
    emit(LayoutChanged());
  }

  final pages = [
    ChatsView(),
    UsersView(),
    SettingsView(),
  ];
}

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class LayoutChanged extends LayoutStates {}
