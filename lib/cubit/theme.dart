import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit(super.isDark) : super();

  void toggleTheme() {
    final box = Hive.box('theme');

    final isDark = box.get('isDark', defaultValue: false) as bool;
    box.put('isDark', !isDark);
    emit(!isDark);
  }
}
