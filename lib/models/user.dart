class UserModel {
  final String id;
  final String avatar;
  final String bio;
  final String name;
  final String email;
  final String phone;
  final String password;

  UserModel({
    required this.id,
    required this.avatar,
    required this.bio,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'bio': bio,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
