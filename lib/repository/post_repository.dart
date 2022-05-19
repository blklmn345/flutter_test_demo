import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/model/response/post.dart';
import 'package:flutter_test_demo/repository/repository_base.dart';
import 'package:flutter_test_demo/services/api_client.dart';

final postsRepoProvider = Provider(
  (_) => PostRepository(ApiClient.instance),
);

final postListProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(postsRepoProvider).getPosts(),
);

final postDetailProvider = FutureProvider.autoDispose.family<Post?, int>(
  (ref, id) => ref.watch(postsRepoProvider).getPost(id),
);

class PostRepository extends RepositoryBase {
  PostRepository(super.client);

  Future<List<Post>> getPosts() async {
    final res = await client.get('https://jsonplaceholder.typicode.com/posts');
    final json = jsonDecode(res.data ?? '');
    if (json == null || json.isEmpty == true) {
      return [];
    }
    return (json as List<dynamic>)
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Post?> getPost(int id) async {
    final res =
        await client.get('https://jsonplaceholder.typicode.com/posts/$id');
    final json = jsonDecode(res.data ?? '');
    if (json == null || json.isEmpty == true) {
      return null;
    }
    return Post.fromJson(json as Map<String, dynamic>);
  }
}
