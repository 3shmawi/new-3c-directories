import 'package:flutter/material.dart';
import 'package:new_3c/controller/theme_ctrl.dart';
import 'package:new_3c/news_app.dart';
import 'package:new_3c/services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();
  isDarkMode = await _isDarkMode();

  runApp(const NewsApp());
}

Future<bool> _isDarkMode() async {
  return (await HiveService().openBox("theme"))
      .get("isDarkMode", defaultValue: false);
}
