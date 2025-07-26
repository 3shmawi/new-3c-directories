import 'package:flutter/material.dart';

class IntroWidgets extends StatelessWidget {
  const IntroWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      children: List.generate(
                        85,
                        (index) => Container(
                          height: 20,
                          width: 20,
                          color: (index.isEven) ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                height: 380,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              10,
                              (index) => Container(
                                width: 100,
                                height: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: 10,
                            color: Colors.cyan,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              10,
                              (index) => Container(
                                width: 100,
                                height: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: 10,
                            color: Colors.cyan,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Wrap(
                      children: List.generate(
                        51,
                        (index) => Container(
                          height: 20,
                          width: 20,
                          color: (index.isEven) ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        10,
                        (index) => Icon(
                              Icons.flutter_dash,
                              color: colors[index],
                            )),
                  ),
                  SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            50,
                            (index) => Icon(
                                  Icons.flutter_dash,
                                  color: Colors.cyan,
                                )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final colors = [
  Colors.cyan,
  Colors.deepOrange,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.red,
  Colors.yellow,
  Colors.pink,
  Colors.teal,
  Colors.amber,
  Colors.indigo,
];
