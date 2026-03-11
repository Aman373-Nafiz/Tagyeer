import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/posts/posts_bloc.dart';
import '../../../domain/entities/post_entity.dart';
import 'post_detail_page.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_widget.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<PostsBloc>().state;
      if (state is PostsLoaded && state.hasMore && !state.isLoadingMore) {
        context.read<PostsBloc>().add(const FetchMorePosts());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<PostsBloc>().add(const RefreshPosts()),
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<PostsBloc>().add(const FetchPosts()),
            );
          }

          if (state is PostsEmpty) {
            return const AppEmptyWidget(
              message: 'No posts found.',
              icon: Icons.article_outlined,
            );
          }

          if (state is PostsLoaded || state is PostsPaginationError) {
            final posts = state is PostsLoaded
                ? state.posts
                : (state as PostsPaginationError).posts;
            final isLoadingMore = state is PostsLoaded ? state.isLoadingMore : false;
            final hasMore = state is PostsLoaded ? state.hasMore : false;
            final hasPaginationError = state is PostsPaginationError;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostsBloc>().add(const RefreshPosts());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: posts.length + (isLoadingMore || hasPaginationError ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= posts.length) {
                    if (hasPaginationError) {
                      return _PaginationErrorTile(
                        message: (state as PostsPaginationError).message,
                        onRetry: () =>
                            context.read<PostsBloc>().add(const FetchMorePosts()),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _PostCard(
                    post: posts[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(post: posts[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const _PostCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (post.tags.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: post.tags
                            .take(3)
                            .map((tag) => _TagChip(tag: tag))
                            .toList(),
                      ),
                    ),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_outlined,
                          size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.visibility_outlined,
                          size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${post.views}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          fontSize: 11,
          color: colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PaginationErrorTile extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PaginationErrorTile({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: TextStyle(color: theme.colorScheme.error)),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
