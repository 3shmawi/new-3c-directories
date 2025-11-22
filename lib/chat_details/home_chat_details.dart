import 'package:flutter/material.dart';
import 'package:new_3c/chat_details/widgets/empty_chat_list.dart';
import 'package:new_3c/chat_details/widgets/messages_list.dart';

import '/chat_details/widgets/app_bar_widget.dart';
import '/chat_details/widgets/messages_provider.dart';
import '/chat_details/widgets/send_field.dart';

class HomeChatDetails extends StatelessWidget {
  const HomeChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return StringList(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBarWidget(),
          body: AnimatedCrossFade(
            firstChild: MessagesList(),
            secondChild: EmptyChatList(),
            crossFadeState: StringListProvider.of(context).strings.isEmpty
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 500),
          ),
          bottomNavigationBar: SendFieldWidget(),
        );
      }),
    );
  }
}
