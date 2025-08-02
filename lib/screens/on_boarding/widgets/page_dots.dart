import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {
  const PageDots({this.isSelected = false, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
      ),
      secondChild: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black,
        ),
      ),
      crossFadeState:
          isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}
