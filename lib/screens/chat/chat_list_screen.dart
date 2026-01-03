import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../widgets/chat_list_item.dart';
import '../groups/create_group_screen.dart';
import 'group_chat_screen.dart';
import 'personal_chat_screen.dart';
import 'select_user_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SelectUserScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateGroupScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: chatService.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return const Center(
              child: Text('No chats yet. Start a conversation!'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final currentUserId = authService.currentUser?.uid ?? '';

              if (chat.type == 'group') {
                return FutureBuilder<GroupModel?>(
                  future: chatService.getGroup(chat.id),
                  builder: (context, groupSnapshot) {
                    final group = groupSnapshot.data;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GroupChatScreen(
                              chatId: chat.id,
                              groupId: chat.id,
                            ),
                          ),
                        );
                      },
                      child: ChatListItem(
                        chat: chat,
                        currentUserId: currentUserId,
                        group: group,
                      ),
                    );
                  },
                );
              } else {
                // Personal chat - get other user
                final otherUserId =
                    chat.participants.firstWhere((id) => id != currentUserId);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Omar/#/users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    UserModel? otherUser;
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      otherUser = UserModel.fromMap(
                        userSnapshot.data!.data() as Map<String, dynamic>,
                        userSnapshot.data!.id,
                      );
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PersonalChatScreen(
                              chatId: chat.id,
                              otherUserId: otherUserId,
                            ),
                          ),
                        );
                      },
                      child: ChatListItem(
                        chat: chat,
                        currentUserId: currentUserId,
                        otherUser: otherUser,
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
