class PostModel {
  final String? id;
  final String authorName;
  final String picture;
  final String title;
  final String publishedAt;
  final String description;
  final String authorId;

  PostModel({
    this.id,
    required this.authorName,
    required this.picture,
    required this.title,
    required this.publishedAt,
    required this.description,
    required this.authorId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String?,
      authorName: json['authorName'] as String,
      picture: json['picture'] as String,
      title: json['title'] as String,
      publishedAt: json['publishedAt'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'picture': picture,
      'title': title,
      'publishedAt': publishedAt,
      'description': description,
      'authorId': authorId,
    };
  }

  PostModel copyWith({
    String? id,
    String? authorName,
    String? picture,
    String? title,
    String? publishedAt,
    String? description,
    String? authorId,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      picture: picture ?? this.picture,
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
    );
  }
}
