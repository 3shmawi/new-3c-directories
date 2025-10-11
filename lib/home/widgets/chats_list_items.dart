import 'package:flutter/material.dart';

import 'home_list_item.dart';

class ChatsListItems extends StatelessWidget {
  const ChatsListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => HomeItem(
        name: "N a m e $index",
        img: "https://picsum.photos/20$index",
        message: "M e s s a g e f r o m N a m e$index",
        time: "0${index + 1}:00 AM",
      ),
    );
  }
}
