part of 'posts_cubit.dart';

abstract class PostsState {
}

class PostsInitialState extends PostsState { }

class PostsLoadingState extends PostsState {
    final List<Posts> oldPosts;
    final bool isFirstFetch;

  PostsLoadingState(this.oldPosts, {this.isFirstFetch = false});
}

class PostsLoadedState extends PostsState {
    final List<Posts> posts;
    final bool hasError;

    PostsLoadedState(this.posts, this.hasError);
}
