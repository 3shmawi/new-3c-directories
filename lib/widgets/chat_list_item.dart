import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../utils/helpers.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final String currentUserId;
  final UserModel? otherUser;
  final GroupModel? group;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.currentUserId,
    this.otherUser,
    this.group,
  });

  String get displayName {
    if (chat.type == 'group' && group != null) {
      return group!.name;
    }
    return otherUser?.name ?? 'Unknown';
  }

  String? get displayImage {
    if (chat.type == 'group' && group != null) {
      return group!.imageUrl;
    }
    return otherUser?.profileImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[300],
        backgroundImage: displayImage != null
            ? CachedNetworkImageProvider(displayImage!)
            : null,
        child: displayImage == null
            ? Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 20),
              )
            : null,
      ),
      title: Text(
        displayName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: chat.lastMessageTime != null
          ? Text(
              formatTimeAgo(chat.lastMessageTime!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
    );
  }
}

