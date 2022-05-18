import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/repository/post_repository.dart';
import 'package:flutter_test_demo/routes/router.dart';

class PostList extends ConsumerWidget {
  const PostList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: posts.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(postListProvider);
            },
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Text(item.id.toString()),
                      title: Text(item.title),
                      subtitle: Text(item.body),
                      trailing: Text(item.userId.toString()),
                      onTap: () => Navigator.of(context).pushNamed(
                        Routes.postDetail,
                        arguments: item.id.toString(),
                      ),
                    ),
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
