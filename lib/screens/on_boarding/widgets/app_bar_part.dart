import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_3c/screens/on_boarding/logic/on_board_logic.dart';

class AppBarPart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPart(this._logic, {this.onSkip, super.key});

  final OnboardLogic _logic;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      foregroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "${_logic.currentPageIndex + 1}",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "/${_logic.onBoardingData.length}",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: Text(
            "Skip",
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
