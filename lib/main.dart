import 'dart:developer';

import 'package:flutter/material.dart';

//debug, profile, release
void main() {
  print("Hello, World!");
  log("Logging from Dart!", time: DateTime.now());

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: Text(
            "Hello lkjsldf alskdfjl;as dflasdkfjlaskdf jalsdj ...",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 50,
              color: Colors.cyan,
              backgroundColor: Colors.black,
              fontWeight: FontWeight.w100,
              letterSpacing: 5.0,
              decoration: TextDecoration.underline,
              decorationColor: Colors.cyan,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
        ),
      ),
    ),
  );
}

/// alt enter

//Text
//Center
//Banner
