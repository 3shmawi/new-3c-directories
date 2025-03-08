class MessageModel {
  final String id;
  final String text;
  final String sendTime;
  final String updatedTime;
  final String senderId;
  final String receiverId;
  String? fileUrl;

  MessageModel({
    required this.id,
    required this.text,
    required this.sendTime,
    required this.updatedTime,
    required this.senderId,
    required this.receiverId,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'send_time': sendTime,
      'updated_time': updatedTime,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'file_url': fileUrl,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      sendTime: json['send_time'],
      updatedTime: json['updated_time'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      fileUrl: json['file_url'],
    );
  }
}
