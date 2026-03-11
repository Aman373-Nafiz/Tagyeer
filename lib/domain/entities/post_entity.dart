class PostEntity {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final int views;
  final int likes;
  final int dislikes;

  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.views,
    required this.likes,
    required this.dislikes,
  });
}
