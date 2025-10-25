import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    required this.isMyMessage,
    super.key,
  });

  final bool isMyMessage;

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
              child: Text(
                "message from me kjasdf;k asdkflj al;ds as;dkljasdkf ja;dksfj al;dksfj adkjl sdkfjl kdsfj adksfjl;dsf l;ksj;ksl;kdl;kdslkdsflkdsaldksfa;dksaldka s;dfl;k sadk lfas dlfk;jas dfl;k asjdfl;kas jdf sajkfas dlf; jsdl;kds f;lkdsjf al;dksfa;dkf ldksf;dksfdksjldksfldksjldksf as;dkflas;dkfasdfkj;ldkfj as;dkfj asfljsadf j",
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
