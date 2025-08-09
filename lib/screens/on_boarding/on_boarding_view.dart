import 'package:flutter/material.dart';
import 'package:new_3c/screens/on_boarding/logic/on_board_logic.dart';
import 'package:new_3c/screens/on_boarding/widgets/app_bar_part.dart';
import 'package:new_3c/screens/on_boarding/widgets/body_part.dart';
import 'package:new_3c/screens/on_boarding/widgets/bottom_part.dart';

import '../auth/login/login_screen.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final _logic = OnboardLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPart(
        _logic,
        onSkip: () {
          setState(() {
            _logic.skipToLastPage();
          });
        },
      ),
      body: BodyPart(_logic),
      bottomSheet: BottomPart(
        _logic,
        onNext: () {
          if (_logic.isLastPage) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          } else {
            setState(() {
              _logic.nextPage();
            });
          }
        },
        onPrevious: () {
          setState(() {
            _logic.previousPage();
          });
        },
      ),
    );
  }
}
