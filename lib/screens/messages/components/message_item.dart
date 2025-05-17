import 'package:flutter/material.dart';
import 'package:new_3c/models/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    this.isSender = true,
    this.messageModel,
    super.key,
  });

  final bool isSender;
  final MessageModel? messageModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
            right: isSender ? 10 : 100, left: isSender ? 100 : 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.cyan : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(isSender ? 25 : 12),
            topLeft: Radius.circular(isSender ? 12 : 25),
            bottomLeft: Radius.circular(isSender ? 12 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 12),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: messageModel?.text,
                  style: TextStyle(
                      color: isSender ? Colors.grey[900] : Colors.cyan[900])),
              TextSpan(text: "\n"),
              TextSpan(
                text: messageModel?.time,
                style: TextStyle(
                  fontSize: 11,
                  color: isSender ? Colors.grey[300] : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
