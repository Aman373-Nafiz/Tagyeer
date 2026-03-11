import '../entities/post_entity.dart';
import '../../core/errors/failures.dart';

abstract class PostsRepository {
  Future<(List<PostEntity>?, Failure?)> getPosts({
    required int limit,
    required int skip,
  });
}
