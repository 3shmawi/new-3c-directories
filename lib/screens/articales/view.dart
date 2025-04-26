import 'package:flutter/material.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Article View',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }
}
