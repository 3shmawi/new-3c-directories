class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final bool isActive;
  final bool isMale;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.isActive,
    required this.isMale,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'is_active': isActive,
      'is_male': isMale,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      isActive: json['is_active'],
      isMale: json['is_male'],
    );
  }
}
