import 'package:new_3c/models/user.dart';

class ChatModel {
  final String id;
  final String lastMessage;
  final String messageDate;
  final UserModel receiver; // aggregation
  bool isMessageRead;

  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.messageDate,
    required this.receiver,
    required this.isMessageRead,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'message_mate': messageDate,
      'receiver': receiver.toJson(),
      'is_message_read': isMessageRead,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      lastMessage: json['last_message'],
      messageDate: json['message_date'],
      receiver: UserModel.fromJson(json['receiver']),
      isMessageRead: json['is_message_read'],
    );
  }
}
