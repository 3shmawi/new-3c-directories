import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.image, {super.key});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: _boxDecoration(),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.yellow, width: 3),
      boxShadow: _boxShadow(),
      image: DecorationImage(
        image: NetworkImage(image),
      ),
    );
  }

  List<BoxShadow> _boxShadow() {
    return [
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
    ];
  }
}
