import 'package:flutter/material.dart';
import 'package:new_3c/news_app.dart';
import 'package:new_3c/services/dio_service.dart';

void main() async {
  await HttpUtil().get("posts");
  runApp(NewsApp());
}
