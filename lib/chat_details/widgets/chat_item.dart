import 'package:flutter/material.dart';

import 'messages_provider.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    required this.isMyMessage,
    required this.message,
    super.key,
  });

  final bool isMyMessage;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMyMessage ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: isMyMessage ? 200 : 10,
          right: isMyMessage ? 10 : 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(isMyMessage ? 20 : 15),
                  topLeft: Radius.circular(isMyMessage ? 15 : 20),
                  bottomLeft: isMyMessage ? Radius.circular(15) : Radius.zero,
                  bottomRight: !isMyMessage ? Radius.circular(15) : Radius.zero,
                ),
              ),
              child: InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog.adaptive(
                          title: Text("Delete message?!"),
                          content: Text(
                              "Are you sure you need to delete this message?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  StringListProvider.of(context)
                                      .removeString(message);
                                  Navigator.of(context).pop();
                                },
                                child: Text("confirm")),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("cancel"),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  message,
                ),
              ),
            ),
            Text("  03:00 PM",
                style: TextStyle(fontSize: 10, color: Colors.grey[400]))
          ],
        ),
      ),
    );
  }
}
