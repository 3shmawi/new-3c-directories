import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/chat_service.dart';
import 'personal_chat_screen.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log(snapshot.error.toString());

            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index];
              final user = UserModel.fromMap(userData, userData['id']);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? Text(user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?')
                      : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () async {
                  try {
                    final chatId =
                        await chatService.getOrCreatePersonalChat(user.id);
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PersonalChatScreen(
                            chatId: chatId,
                            otherUserId: user.id,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
