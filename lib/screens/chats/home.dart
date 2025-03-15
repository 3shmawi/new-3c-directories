import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/chat.dart';
import 'package:new_3c/models/chat.dart';
import 'package:new_3c/screens/messages/view.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
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
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(chats[index].lastMessage),
                  subtitle: Text(chats[index].receiverRef.id),
                ),
              ),
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
                      child: ChatsDetails(users[index]),
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
