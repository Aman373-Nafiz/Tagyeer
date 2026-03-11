import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import '../../../core/constants/app_constants.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;
  int _currentSkip = 0;

  PostsBloc({required this.getPostsUseCase}) : super(const PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<FetchMorePosts>(_onFetchMorePosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsLoading());
    _currentSkip = 0;

    final (posts, failure) = await getPostsUseCase(
      limit: AppConstants.pageLimit,
      skip: _currentSkip,
    );

    if (failure != null) {
      emit(PostsError(failure.message));
    } else if (posts == null || posts.isEmpty) {
      emit(const PostsEmpty());
    } else {
      _currentSkip += posts.length;
      emit(PostsLoaded(
        posts: posts,
        hasMore: posts.length == AppConstants.pageLimit,
      ));
    }
  }

  Future<void> _onFetchMorePosts(
    FetchMorePosts event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostsLoaded || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final (newPosts, failure) = await getPostsUseCase(
      limit: AppConstants.pageLimit,
      skip: _currentSkip,
    );

    if (failure != null) {
      emit(PostsPaginationError(
        posts: currentState.posts,
        message: failure.message,
      ));
    } else if (newPosts != null) {
      _currentSkip += newPosts.length;
      final allPosts = [...currentState.posts, ...newPosts];
      emit(PostsLoaded(
        posts: allPosts,
        hasMore: newPosts.length == AppConstants.pageLimit,
      ));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostsState> emit,
  ) async {
    add(const FetchPosts());
  }
}
