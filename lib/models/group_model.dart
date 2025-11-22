import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String adminId;
  final List<String> members;
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.adminId,
    required this.members,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
      adminId: map['adminId'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'adminId': adminId,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
