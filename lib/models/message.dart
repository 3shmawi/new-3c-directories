import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_3c/models/user.dart';

class MessageModel {
  final String id;
  final String text;
  final String sendTime;
  final String updatedTime;
  final DocumentReference senderRef; // Firestore reference to sender
  final DocumentReference receiverRef; // Firestore reference to receiver
  String? fileUrl;

  MessageModel({
    required this.id,
    required this.text,
    required this.sendTime,
    required this.updatedTime,
    required this.senderRef,
    required this.receiverRef,
    this.fileUrl,
  });

  /// Convert model to Firestore-friendly JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'send_time': sendTime,
      'updated_time': updatedTime,
      'sender_ref': senderRef, // Store Firestore doc ref
      'receiver_ref': receiverRef, // Store Firestore doc ref
      'file_url': fileUrl,
    };
  }

  /// Create model from Firestore document
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      sendTime: json['send_time'],
      updatedTime: json['updated_time'],
      senderRef:
          json['sender_ref'] as DocumentReference, // Read Firestore doc ref
      receiverRef:
          json['receiver_ref'] as DocumentReference, // Read Firestore doc ref
      fileUrl: json['file_url'],
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
