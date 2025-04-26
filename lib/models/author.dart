class AuthorModel {
  int id;
  String name;
  String avatar;
  String email;
  String bio;
  String phone;

  AuthorModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.bio,
    required this.phone,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'email': email,
      'bio': bio,
      'phone': phone,
    };
  }
}
