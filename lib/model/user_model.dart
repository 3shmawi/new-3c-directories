class UserModel {
  final String? id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? profilePictureUrl;
  final bool? isActive;

  // Constructor
  UserModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.profilePictureUrl,
    this.isActive,
  });

  //Named constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profile_picture_url'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'is_active': isActive,
    };
  }
}
