class PostModel {
  final String id;
  final String? authorId;
  final String? title;
  final String? description;
  final String? picture;
  final String? authorName;
  final String? publishedAt;

  PostModel({
    required this.id,
    this.authorId,
    this.title,
    this.description,
    this.picture,
    this.authorName,
    this.publishedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      authorId: json['authorId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      picture: json['picture'] as String?,
      authorName: json['authorName'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'picture': picture,
      'authorName': authorName,
      'publishedAt': publishedAt,
    };
  }

  PostModel copyWith({
    String? authorId,
    String? title,
    String? description,
    String? picture,
    String? authorName,
    String? publishedAt,
  }) {
    return PostModel(
      id: id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      authorName: authorName ?? this.authorName,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
