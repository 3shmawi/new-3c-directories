import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/screens/articales/view.dart';

import '../screens/new_article/view.dart';
import '../screens/profile/view.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitState());

  static LayoutCtrl get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }

  List<Widget> screens = [
    const ArticleView(),
    const NewArticleView(),
    const ProfileView(),
  ];
}

abstract class LayoutStates {}

class LayoutInitState extends LayoutStates {}

class LayoutChangeBottomNavBarState extends LayoutStates {}
