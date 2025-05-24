import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/app/functions.dart';
import 'package:new_3c/controller/chat_ctrl/chat_cubit.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';
import 'package:new_3c/models/user.dart';

import '../messages/messages_view.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: cubit.getMyChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(
                        fontFamily: "Merienda",
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final chats = snapshot.data!;
                  if (chats.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.snapchat_sharp,
                            size: 50,
                          ),
                          Text("No chats found"),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return FutureBuilder<UserModel>(
                          future: UserCubit().getUserData(
                              UserCubit().senderId == chat.receiverId
                                  ? chat.senderId
                                  : chat.receiverId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  snapshot.error.toString(),
                                  style: const TextStyle(
                                    fontFamily: "Merienda",
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              final user = snapshot.data!;

                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    final participants = chat.participants;
                                    participants.sort();
                                    final chatId = await ChatCubit()
                                        .fetchOrCreateChat(participants.first,
                                            participants.last);
                                    context.push(MessagesView(chatId));
                                  },
                                  title: Text(user.name),
                                  subtitle: Row(
                                    children: [
                                      Text(chat.lastMessage),
                                      const Spacer(),
                                      Text(daysBetween(chat.lastMessageTime))
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(user.imgUrl),
                                  ),
                                  trailing: StreamBuilder<bool>(
                                      stream: UserCubit().isOnline(user.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.grey[300],
                                          );
                                        }
                                        final isOnline = snapshot.data;
                                        if (isOnline == null) {
                                          return CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.grey[300],
                                          );
                                        }
                                        return CircleAvatar(
                                          radius: 5,
                                          backgroundColor: isOnline
                                              ? Colors.green[500]
                                              : Colors.grey[300],
                                        );
                                      }),
                                ),
                              );
                            }
                            return const Center(
                                child: Text("No user data found"));
                          });
                    },
                  );
                }
                return const Center(child: Text("No users found"));
              },
            ),
          );
        },
      ),
    );
  }
}
