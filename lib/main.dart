import 'package:flutter/material.dart';
import 'package:new_3c/my_app.dart';
import 'package:new_3c/services/dio_helper.dart';

void main() async {
  await APIRequestsHelper().get("posts/23");

  runApp(MyApp());
}
