import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String lastMessage;
  final String lastMessageTime;
  final String lastSenderId;
  final String lastMessageType;
  final bool isSenderSeeChat;
  final bool isReceiverSeeChat;
  final List<String> participants;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.lastMessageType,
    required this.isSenderSeeChat,
    required this.isReceiverSeeChat,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'last_sender_id': lastSenderId,
      'last_message_type': lastMessageType,
      'is_sender_see_chat': isSenderSeeChat,
      'is_receiver_see_chat': isReceiverSeeChat,
      'participants': participants,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? "",
      senderId: json['sender_id'] ?? "",
      receiverId: json['receiver_id'] ?? "",
      lastMessage: json['last_message'] ?? "",
      lastMessageTime: json['last_message_time'] ?? Timestamp.now(),
      lastSenderId: json['last_sender_id'] ?? "",
      lastMessageType: json['last_message_type'] ?? "",
      isSenderSeeChat: json['is_sender_see_chat'] ?? false,
      isReceiverSeeChat: json['is_receiver_see_chat'] ?? false,
      participants: List<String>.from(json['participants'] ?? []),
    );
  }
}
