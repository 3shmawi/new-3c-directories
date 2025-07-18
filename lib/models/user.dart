class UserModel {
  UserModel({
    this.avatar,
    this.name,
    this.bio,
    this.email,
    this.phone,
    this.password,
    this.id,
  });

  UserModel.fromJson(dynamic json) {
    avatar = json['avatar'];
    name = json['name'];
    bio = json['bio'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    id = json['id'];
  }

  String? avatar;
  String? name;
  String? bio;
  String? email;
  String? phone;
  String? password;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['avatar'] = avatar;
    map['name'] = name;
    map['bio'] = bio;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['id'] = id;
    return map;
  }
}
