import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.userId,
    required super.tags,
    required super.views,
    required super.likes,
    required super.dislikes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      likes: json['reactions']?['likes'] ?? json['likes'] ?? 0,
      dislikes: json['reactions']?['dislikes'] ?? json['dislikes'] ?? 0,
    );
  }
}
