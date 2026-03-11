import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts({required int limit, required int skip});
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> getPosts({
    required int limit,
    required int skip,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.postsEndpoint}?limit=$limit&skip=$skip',
      );

      final response = await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final posts = data['posts'] as List;
        return posts.map((p) => PostModel.fromJson(p)).toList();
      } else {
        throw ServerException(
            message: 'Failed to fetch posts.', statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
