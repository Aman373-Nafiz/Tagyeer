part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostsEvent {
  const FetchPosts();
}

class FetchMorePosts extends PostsEvent {
  const FetchMorePosts();
}

class RefreshPosts extends PostsEvent {
  const RefreshPosts();
}
