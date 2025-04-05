import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/auth.dart';
import 'package:new_3c/controller/chat.dart';
import 'package:new_3c/models/chat.dart';
import 'package:new_3c/models/user.dart';
import 'package:new_3c/screens/auth/login.dart';
import 'package:new_3c/screens/messages/view.dart';
import 'package:shimmer/shimmer.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
              onPressed: () {
                AuthCubit().logout().then((isLoggedOut) {
                  if (isLoggedOut) {
                    ToastHandler.showInfo("You have logged out successfully");
                    context.pushReplacementAll(LoginPage());
                  } else {
                    ToastHandler.showError(
                        "Can't logout, please try again later");
                  }
                });
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ChatModel>>(
          stream: ChatCubit().getChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chats = snapshot.data;

            if (chats == null || chats.isEmpty) {
              return Center(
                child: Text("no chats yet"),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                return FutureBuilder<UserModel>(
                  future: ChatCubit().getUser(chats[index].receiverRef.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[300]!,
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(),
                            title: Text(""),
                            subtitle: Text(""),
                          ),
                        ),
                      );
                    }

                    final receiver = snapshot.data;
                    if (receiver == null) {
                      return SizedBox.shrink();
                    }
                    return Card(
                      child: ListTile(
                        onTap: () {
                          context.push(BlocProvider(
                            create: (context) => ChatCubit(),
                            child: ChatsDetails(receiver, false),
                          ));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(receiver.avatar),
                        ),
                        title: Text(receiver.name),
                        subtitle: Text(chats[index].lastMessage),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: chats.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => UserListUi(),
          );
        },
      ),
    );
  }
}

class UserListUi extends StatelessWidget {
  const UserListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()..getAllUsers(),
      child: BlocBuilder<ChatCubit, ChatStates>(
        builder: (context, state) {
          final users = context.read<ChatCubit>().users;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {
                    context.push(BlocProvider(
                      create: (context) => ChatCubit(),
                      child: ChatsDetails(users[index], true),
                    ));
                  },
                  title: Text(users[index].name),
                  subtitle: Text(users[index].email),
                ),
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: users.length,
            ),
          );
        },
      ),
    );
  }
}
