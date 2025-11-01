import 'package:flutter/material.dart';
import 'package:new_3c/chat_details/widgets/app_bar_widget.dart';
import 'package:new_3c/chat_details/widgets/chat_item.dart';
import 'package:new_3c/chat_details/widgets/messages_provider.dart';
import 'package:new_3c/chat_details/widgets/send_field.dart';

class HomeChatDetails extends StatelessWidget {
  const HomeChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return StringList(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBarWidget(),
          body: AnimatedCrossFade(
            firstChild: ListView.separated(
                itemBuilder: (context, index) => ChatItem(
                      isMyMessage: index.isEven,
                      message: StringListProvider.of(context).strings[index],
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: StringListProvider.of(context).strings.length),
            secondChild: Center(
              child: Icon(
                Icons.list,
                size: 100,
                color: Colors.grey[400],
              ),
            ),
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
