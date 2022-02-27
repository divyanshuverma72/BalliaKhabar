import 'package:bloc/bloc.dart';
import 'package:flutterapp/bloc/posts/posts_repository.dart';
import 'package:flutterapp/bloc/posts/posts_service.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this.postsRepository) : super(PostsInitialState());

  int page = 1;
  final PostsRepository postsRepository;

  void loadPosts(bool refresh) {
    if (refresh) {
      page = 1;
    }
    if (state is PostsLoadingState) return;

    final currentState = state;

    var oldPosts = <Posts>[];
    if (currentState is PostsLoadedState) {
      oldPosts = currentState.posts;
    }

    emit(PostsLoadingState(oldPosts, isFirstFetch: page == 1));

    postsRepository.fetchPosts(page).then((newPosts) {

      final posts = (state as PostsLoadingState).oldPosts;
      posts.addAll(newPosts);

      if (newPosts.isEmpty) {
        emit(PostsLoadedState(posts, true));
      } else {
        page++;
        emit(PostsLoadedState(posts, false));
      }
    });
  }
}
