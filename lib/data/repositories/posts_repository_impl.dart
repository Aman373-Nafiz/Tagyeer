import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<(List<PostEntity>?, Failure?)> getPosts({
    required int limit,
    required int skip,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return (null, const NetworkFailure());
    }

    try {
      final posts = await remoteDataSource.getPosts(limit: limit, skip: skip);
      return (posts as List<PostEntity>, null);
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }
}
