import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/my_app.dart';

/// dio    =>   flutter pub add dio
///
/// API = https://680ce6282ea307e081d55f2a.mockapi.io/posts

//asyncroinizaiton
void main() async {
  final dio = Dio();

  final response =
      await dio.get("https://680ce6282ea307e081d55f2a.mockapi.io/posts");

  log(response.data[0].toString());
  print(response.data[0].toString());
  debugPrint(response.data[0].toString());

  runApp(MyApp());
}
