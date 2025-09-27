import 'package:flutter/material.dart';
import 'package:new_3c/home/widgets/avatar.dart';
import 'package:new_3c/home/widgets/story_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100, child: _stories()),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Avatar("https://picsum.photos/200"),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("message"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _stories() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: 9,
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemBuilder: (context, index) => StoryItem(
        name: "name$index",
        image: "https://picsum.photos/20$index",
      ),
    );
  }
}
