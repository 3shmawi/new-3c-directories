import 'package:flutter/material.dart';
import 'package:new_3c/services/local_storage_helper.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}
