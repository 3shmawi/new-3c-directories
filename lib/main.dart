import 'package:flutter/material.dart';
import 'package:new_3c/news_app.dart';
import 'package:new_3c/services/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  runApp(const NewsApp());
}
