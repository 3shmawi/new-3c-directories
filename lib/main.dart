//https://dog.ceo/api/breeds/image/random

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

///dio package
///
/// assynchronisation
void main() async {
  final dio = Dio();

  final response = await dio.get('https://dog.ceo/api/breeds/image/random');
  log(response.data.toString());

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Dio Example')),
      body: Center(
        child: Image.network(response.data['message']),
      ),
    ),
  ));
}
