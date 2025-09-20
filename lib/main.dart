import 'dart:developer';

import 'package:flutter/material.dart';

//debug, profile, release
void main() {
  print("Hello, World!");
  log("Logging from Dart!", time: DateTime.now());
  final images = [
    "https://picsum.photos/200",
    "https://picsum.photos/201",
    "https://picsum.photos/202",
    "https://picsum.photos/203",
    "https://picsum.photos/204",
    "https://picsum.photos/205",
    "https://picsum.photos/206",
    "https://picsum.photos/207",
    "https://picsum.photos/208",
    "https://picsum.photos/209",
  ];

  final names = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Frank",
    "Grace",
    "Hannah",
    "Ivy",
    "Jack"
  ];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: Column(
            spacing: 30,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    spacing: 10,
                    children: List.generate(
                      images.length,
                      (index) => Column(
                        spacing: 10,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.yellow, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .6),
                                  blurRadius: 10,
                                  offset: Offset(10, 10),
                                ),
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: .6),
                                  blurRadius: 10,
                                  offset: Offset(-10, -10),
                                )
                              ],
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                              ),
                            ),
                          ),
                          Text(names[index]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("olloH"),
                      Icon(Icons.arrow_left),
                      Text("olloH"),
                    ],
                  ),
                  Text("Hello"),
                  Icon(Icons.arrow_left),
                  Icon(Icons.arrow_right),
                  Text("Hello"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello"),
                      Icon(Icons.arrow_left),
                      Text("Hello"),
                    ],
                  )
                ],
              ),

              //container
            ],
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

///layout
//Row
//Column
//Stack
//Listview
