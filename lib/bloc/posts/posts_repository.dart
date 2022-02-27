import 'package:flutterapp/bloc/posts/posts_service.dart';

class PostsRepository {

  final PostsService service;

  PostsRepository(this.service);

  Future<List<Posts>> fetchPosts(int page) async {
    return await service.fetchPosts(page);
  }
}