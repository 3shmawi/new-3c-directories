import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/screens/new_article/view.dart';
import 'package:new_3c/screens/newsletter/view.dart';
import 'package:new_3c/screens/profile/view.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitialState());

  static LayoutCtrl get(context) => BlocProvider.of(context);

  final List<Widget> screens = [
    NewsletterView(),
    NewArticleView(),
    ProfileView(),
  ];

  int currentIndex = 0;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }
}

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class ChangeBottomNavBarState extends LayoutStates {}
