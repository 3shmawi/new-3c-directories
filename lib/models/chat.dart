import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_3c/models/user.dart';

class ChatModel {
  final String id;
  final DocumentReference senderRef; // Firestore reference to sender
  final DocumentReference receiverRef; // Firestore reference to receiver
  final String lastMessage;
  final String messageDate;
  bool isMessageRead;

  ChatModel({
    required this.id,
    required this.senderRef,
    required this.receiverRef,
    required this.lastMessage,
    required this.messageDate,
    required this.isMessageRead,
  });

  /// Convert model to Firestore-friendly JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_ref': senderRef, // Store Firestore doc ref
      'receiver_ref': receiverRef, // Store Firestore doc ref
      'last_message': lastMessage,
      'message_date': messageDate,
      'is_message_read': isMessageRead,
    };
  }

  /// Create model from Firestore document
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      senderRef:
          json['sender_ref'] as DocumentReference, // Read Firestore doc ref
      receiverRef:
          json['receiver_ref'] as DocumentReference, // Read Firestore doc ref
      lastMessage: json['last_message'],
      messageDate: json['message_date'],
      isMessageRead: json['is_message_read'],
    );
  }

  /// Fetch sender's full UserModel from Firestore
  Future<UserModel> getSenderDetails() async {
    final senderDoc = await senderRef.get();
    return UserModel.fromJson(senderDoc.data() as Map<String, dynamic>);
  }

  /// Fetch receiver's full UserModel from Firestore
  Future<UserModel> getReceiverDetails() async {
    final receiverDoc = await receiverRef.get();
    return UserModel.fromJson(receiverDoc.data() as Map<String, dynamic>);
  }
}
