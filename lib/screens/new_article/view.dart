import 'package:flutter/material.dart';

class NewArticleView extends StatelessWidget {
  const NewArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New Article',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
