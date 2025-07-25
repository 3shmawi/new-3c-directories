import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/local_storage.dart';

bool isDarkMode = false;

class ThemeCtrl extends Cubit<bool> {
  ThemeCtrl() : super(isDarkMode);

  static ThemeCtrl get(context) => BlocProvider.of<ThemeCtrl>(context);

  void toggleTheme() async {
    final box = await HiveService().openBox("theme");
    final state = !this.state;
    await box.put("isDarkMode", state);
    emit(state);
  }
}
