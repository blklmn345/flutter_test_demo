import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/model/response/post.dart';
import 'package:flutter_test_demo/repository/post_repository.dart';

class PostDetail extends ConsumerWidget {
  final int postId;

  const PostDetail({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postFuture = ref.watch(postDetailProvider(postId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
      ),
      body: postFuture.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: Text('error'),
            );
          }
          return _PostDetailBody(
            post: data,
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

class _PostDetailBody extends StatelessWidget {
  final Post post;
  const _PostDetailBody({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 20,
          child: Text(
            post.id.toString(),
            style: TextStyle(
              fontSize: 140,
              fontStyle: FontStyle.italic,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      post.body,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
