import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/model/response/post.dart';
import 'package:flutter_test_demo/model/response/user.dart';
import 'package:flutter_test_demo/repository/post_repository.dart';
import 'package:flutter_test_demo/repository/user_repository.dart';
import 'package:flutter_test_demo/routes/router.dart';
import 'package:collection/collection.dart';

final _postAndUserProvider = FutureProvider((ref) async {
  final posts = await ref.read(postsRepoProvider).getPosts();
  final users = (await Future.wait(
    posts.map((e) => ref.read(userRepoProvider).getUser(e.userId)).toList(),
  ))
      .whereType<User>()
      .toList();

  return Future.value([posts, users]);
});

class PostList extends ConsumerWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAndUser = ref.watch(_postAndUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: postsAndUser.when(
        data: (postsAndUser) {
          final posts = (postsAndUser[0] as List<Post>);
          final users = (postsAndUser[1] as List<User>);
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(_postAndUserProvider);
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final item = posts[index];
                final user = users.firstWhereOrNull((e) => e.id == item.userId);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _PostListTile(
                    item: item,
                    user: user,
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _PostListTile extends ConsumerWidget {
  const _PostListTile({
    Key? key,
    required this.item,
    required this.user,
  }) : super(key: key);

  final Post item;
  final User? user;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      child: ListTile(
        leading: Text(user?.username ?? 'Unknown'),
        title: Text(item.title),
        subtitle: Text(item.body),
        trailing: Text(item.userId.toString()),
        onTap: () => Navigator.of(context).pushNamed(
          Routes.postDetail,
          arguments: item.id.toString(),
        ),
      ),
    );
  }
}
