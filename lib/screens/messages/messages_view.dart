import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';

import 'components/message_item.dart';

class MessagesView extends StatelessWidget {
  const MessagesView(this.chatId, {super.key});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text("Chat messages"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => MessageItem(
          isSender: index % 4 == 0,
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemCount: 10,
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Type you message",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
