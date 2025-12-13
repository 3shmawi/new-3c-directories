import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(InitialThemeState());

  bool isDark = false;
  void toggleTheme() {
    isDark = !isDark;
    emit(ToggleThemeState());
  }
}

//Provide
//builder || Lisenter

abstract class ThemeStates {}

class InitialThemeState extends ThemeStates {}

class ToggleThemeState extends ThemeStates {}
