import 'dart:convert';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.image, {this.size = const Size.square(50), super.key});

  final String image;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
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
        image: isValidUrl()
            ? NetworkImage(image)
            : MemoryImage(base64Decode(image)),
      ),
    );
  }

  bool isValidUrl() {
    Uri? uri = Uri.tryParse(image);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
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
