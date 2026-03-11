part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  final bool hasMore;
  final bool isLoadingMore;

  const PostsLoaded({
    required this.posts,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  PostsLoaded copyWith({
    List<PostEntity>? posts,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [posts, hasMore, isLoadingMore];
}

class PostsError extends PostsState {
  final String message;
  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostsEmpty extends PostsState {
  const PostsEmpty();
}

class PostsPaginationError extends PostsState {
  final List<PostEntity> posts;
  final String message;
  const PostsPaginationError({required this.posts, required this.message});

  @override
  List<Object?> get props => [posts, message];
}
