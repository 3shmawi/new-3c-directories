import 'package:flutter/material.dart';
import 'package:new_3c/screens/widgets/app_bar_part.dart';
import 'package:new_3c/screens/widgets/news_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPart(),
      body: ListView.builder(
        itemBuilder: (context, index) => NewsItem(),
        itemCount: 10,
      ),
    );
  }
}
