import 'package:flutter/material.dart';

class NewsletterView extends StatelessWidget {
  const NewsletterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Newsletter',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }
}
