class Article {
  int id;
  String title;
  String description;
  String picture;
  String publishedAt;
  String authorName;
  String authorId;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.picture,
    required this.publishedAt,
    required this.authorName,
    required this.authorId,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      picture: json['picture'] as String,
      publishedAt: json['publishedAt'] as String,
      authorName: json['authorName'] as String,
      authorId: json['authorId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'picture': picture,
      'publishedAt': publishedAt,
      'authorName': authorName,
      'authorId': authorId,
    };
  }
}
