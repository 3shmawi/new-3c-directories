import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Oauth2Button extends StatelessWidget {
  const Oauth2Button({required this.iconPath, this.onPressed, super.key});

  final String iconPath;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFCF3F6),
          border: Border.all(
            color: Color(0xFFF83758),
            width: 1,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 26,
            width: 26,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              height: 26,
              width: 26,
            ),
          ),
        ),
      ),
    );
  }
}
