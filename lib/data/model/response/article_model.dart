// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
  int? id;
  int? userId;
  String? title;
  String? image;
  String? details;
  String? addedBy;
  int? published;
  DateTime? createdAt;
  DateTime? updatedAt;

  Article({
    this.id,
    this.userId,
    this.title,
    this.image,
    this.details,
    this.addedBy,
    this.published,
    this.createdAt,
    this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        image: json["image"],
        details: json["details"],
        addedBy: json["added_by"],
        published: json["published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "image": image,
        "details": details,
        "added_by": addedBy,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
