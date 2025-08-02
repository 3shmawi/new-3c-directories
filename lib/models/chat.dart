import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String uid;
  final String? displayName;
  final String lastMessage;
  final String? photoURL;
  final DateTime lastMessageTime;
  final String senderId;
  final String? receiverId;
  final List<String> participants;

  ChatModel({
    required this.uid,
    this.displayName,
    required this.lastMessage,
    this.photoURL,
    required this.lastMessageTime,
    required this.senderId,
    this.receiverId,
    required this.participants,
  }) : assert(participants.isNotEmpty, 'Participants cannot be empty');

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      uid: data['uid'] ?? '',
      displayName: data['display_name'],
      lastMessage: data['last_message'] ?? '',
      photoURL: data['photo_url'],
      lastMessageTime: (data['last_message_time'] as Timestamp).toDate(),
      senderId: data['sender_id'] ?? '',
      receiverId: data['receiver_id'],
      participants: (List<String>.from(data['participants'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'last_message': lastMessage,
      'photo_url': photoURL,
      'last_message_time': lastMessageTime.toUtc(),
      'sender_id': senderId,
      'receiver_id': receiverId,
      'participants': participants,
    };
  }

  ChatModel copyWith({
    String? displayName,
    String? lastMessage,
    String? photoURL,
    DateTime? lastMessageTime,
    String? senderId,
    String? receiverId,
    List<String>? participants,
  }) {
    return ChatModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      lastMessage: lastMessage ?? this.lastMessage,
      photoURL: photoURL ?? this.photoURL,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      participants: participants ?? this.participants,
    );
  }

  bool get isGroupChat => participants.length > 2;
}
