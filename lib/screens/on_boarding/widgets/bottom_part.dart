import 'package:flutter/material.dart';
import 'package:new_3c/screens/on_boarding/widgets/page_dots.dart';

import '../logic/on_board_logic.dart';

class BottomPart extends StatelessWidget {
  const BottomPart(this._logic, {this.onPrevious, this.onNext, super.key});

  final OnboardLogic _logic;

  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Opacity(
          opacity: _logic.isFirstPage ? 0 : 1.0,
          child: TextButton(
            onPressed: onPrevious,
            child: Text(
              "Prev",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey),
            ),
          ),
        ),
        Spacer(),
        ...List.generate(
            _logic.onBoardingData.length,
            (index) => PageDots(
                  isSelected: _logic.currentPageIndex == index,
                )),
        Spacer(),
        TextButton(
          onPressed: onNext,
          child: Text(
            _logic.isLastPage ? "Get Started" : "Next",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.red[900]),
          ),
        ),
      ],
    );
  }
}
