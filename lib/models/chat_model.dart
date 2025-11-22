import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String type; // 'personal' or 'group'
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final Map<String, dynamic>? groupInfo;

  ChatModel({
    required this.id,
    required this.type,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.groupInfo,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      type: map['type'] ?? 'personal',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'],
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate(),
      groupInfo: map['groupInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime':
          lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
      'groupInfo': groupInfo,
    };
  }
}
