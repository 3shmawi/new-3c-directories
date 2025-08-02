import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../logic/on_board_logic.dart';

class BodyPart extends StatelessWidget {
  const BodyPart(this._logic, {super.key});

  final OnboardLogic _logic;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _logic.pageController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                _logic.onBoardingData[index].imagePath,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 15),
              Text(
                _logic.onBoardingData[index].title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _logic.onBoardingData[index].description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: _logic.onBoardingData.length,
    );
  }
}
