class UserModel {
  final String id;
  String name;
  String email;
  String phone;
  String imgUrl;
  bool isOnline;
  bool isMale;
  String bio;
  String? fcmToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.imgUrl,
    required this.isOnline,
    required this.isMale,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'img_url': imgUrl,
      'is_online': isOnline,
      'is_male': isMale,
      'fcm_token': fcmToken,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      imgUrl: json['img_url'],
      isOnline: json['is_online'],
      isMale: json['is_male'],
      fcmToken: json['fcm_token'],
    );
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? bio,
    String? imgUrl,
    bool? isMale,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      imgUrl: imgUrl ?? this.imgUrl,
      isOnline: isOnline,
      isMale: isMale ?? this.isMale,
    );
  }
}
