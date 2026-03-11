import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';
import '../../core/errors/failures.dart';

class GetPostsUseCase {
  final PostsRepository repository;

  GetPostsUseCase(this.repository);

  Future<(List<PostEntity>?, Failure?)> call({
    required int limit,
    required int skip,
  }) {
    return repository.getPosts(limit: limit, skip: skip);
  }
}
