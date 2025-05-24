import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/chat_ctrl/chat_cubit.dart';
import 'package:new_3c/models/message.dart';

import 'components/message_item.dart';

class MessagesView extends StatelessWidget {
  const MessagesView(this.chatId, {super.key});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is SendMessageErrorState) {
            context.showError(state.errorMsg);
          }
        },
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
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
            body: StreamBuilder<List<MessageModel>>(
                stream: cubit.getMessages(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              fontFamily: "Merienda",
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final message = snapshot.data!;
                  if (message.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wechat_sharp,
                            color: Colors.grey,
                            size: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No messages yet",
                            style: TextStyle(
                              fontFamily: "Merienda",
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) => MessageItem(
                      isSender: message[index].senderId == cubit.currentUserId,
                      messageModel: message[index],
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemCount: message.length,
                  );
                }),
            bottomSheet: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cubit.messageCtrl,
                      decoration: InputDecoration(
                        hintText: "Type you message",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.sendMessage(chatId);
                    },
                    icon: Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
