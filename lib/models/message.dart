class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String time;
  final String type;
  final String? fileUrl;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.time,
    required this.type,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'time': time,
      'type': type,
      'file_url': fileUrl,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      text: json['text'],
      time: json['time'],
      type: json['type'],
      fileUrl: json['file_url'],
    );
  }
}
