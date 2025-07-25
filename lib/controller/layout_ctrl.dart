import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/views/layout/create_feed/create_feed_view.dart';

import '../views/layout/feeds/feeds_view.dart';
import '../views/layout/profile/profile_view.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitialState());

  static LayoutCtrl get(context) => BlocProvider.of<LayoutCtrl>(context);

  int currentIndex = 0;

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState(index));
  }

  final views = [
    const FeedsView(),
    const CreateFeedView(),
    const ProfileView(),
  ];
}

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class ChangeBottomNavState extends LayoutStates {
  final int index;

  ChangeBottomNavState(this.index);
}
