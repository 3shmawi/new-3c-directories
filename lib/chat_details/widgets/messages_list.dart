import 'package:flutter/material.dart';

import 'chat_item.dart';
import 'messages_provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => ChatItem(
              isMyMessage: index.isEven,
              message: StringListProvider.of(context).strings[index],
            ),
        separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
        itemCount: StringListProvider.of(context).strings.length);
  }
}
