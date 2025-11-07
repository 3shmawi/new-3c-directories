class Message {
  final String id;
  final String text;
  final String senderId;
  final DateTime time;
  final bool seen;
  final String? profileAvatar;
  final String? displayName;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.time,
    this.seen = false,
    this.profileAvatar,
    this.displayName,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      senderId: json['sender_id'],
      time: json['time'],
      seen: json['seen'],
      profileAvatar: json['profile_avatar'],
      displayName: json['display_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender_id': senderId,
      'time': time,
      'seen': seen,
      'profile_avatar': profileAvatar,
      'display_name': displayName,
    };
  }
}
