class PostModel {
  final int? id;
  final String authorName;
  final String picture;
  final String title;
  final String publishedAt;
  final String description;
  final int authorId;

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
      id: json['id'] as int,
      authorName: json['authorName'] as String,
      picture: json['picture'] as String,
      title: json['title'] as String,
      publishedAt: json['publishedAt'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as int,
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
    int? id,
    String? authorName,
    String? picture,
    String? title,
    String? publishedAt,
    String? description,
    int? authorId,
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
