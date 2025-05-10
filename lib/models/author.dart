class AuthorModel {
  String id;
  String name;
  String avatar;
  String email;
  String bio;
  String phone;
  String password;

  AuthorModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.bio,
    required this.phone,
    required this.password,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'email': email,
      'bio': bio,
      'phone': phone,
      'password': password,
    };
  }

  AuthorModel copyWith({
    String? name,
    String? avatar,
    String? email,
    String? bio,
    String? phone,
    String? password,
  }) {
    return AuthorModel(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
