import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeThemeState());
    } else {
      isDark = !isDark;
      emit(ChangeThemeState());
    }
  }
}

abstract class SettingsStates {}

class SettingsInitialState extends SettingsStates {}

class ChangeThemeState extends SettingsStates {}
