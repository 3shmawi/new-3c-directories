class PostModel {
  PostModel({
    this.authorName,
    this.picture,
    this.title,
    this.publishedAt,
    this.description,
    this.authorId,
    this.id,
  });

  PostModel.fromJson(dynamic json) {
    authorName = json['authorName'];
    picture = json['picture'];
    title = json['title'];
    publishedAt = json['publishedAt'];
    description = json['description'];
    authorId = json['authorId'];
    id = json['id'];
  }

  String? authorName;
  String? picture;
  String? title;
  String? publishedAt;
  String? description;
  int? authorId;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authorName'] = authorName;
    map['picture'] = picture;
    map['title'] = title;
    map['publishedAt'] = publishedAt;
    map['description'] = description;
    map['authorId'] = authorId;
    map['id'] = id;
    return map;
  }
}
