import 'package:flutter/material.dart';
import 'package:new_3c/chat_details/widgets/app_bar_widget.dart';
import 'package:new_3c/chat_details/widgets/chat_item.dart';
import 'package:new_3c/chat_details/widgets/send_field.dart';

class HomeChatDetails extends StatelessWidget {
  const HomeChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: ListView.separated(
          itemBuilder: (context, index) => ChatItem(
                isMyMessage: index.isEven,
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
          itemCount: 15),
      bottomNavigationBar: SendFieldWidget(),
    );
  }
}
