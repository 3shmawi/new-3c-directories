class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String picture;
  final String authorId;
  final String authorName;
  final String publishedAt;

  ArticleModel({
    required this.title,
    required this.authorName,
    required this.description,
    required this.picture,
    required this.authorId,
    required this.publishedAt,
    required this.id,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      picture: json['picture'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      publishedAt: json['publishedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'picture': picture,
      'authorId': authorId,
      'authorName': authorName,
      'publishedAt': publishedAt,
    };
  }
}
