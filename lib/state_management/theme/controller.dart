import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeController extends Cubit<bool> {
  ThemeController() : super(false);

  void toggleTheme() {
    emit(!state);
  }
}
