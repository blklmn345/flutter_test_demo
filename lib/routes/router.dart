import 'package:flutter/material.dart';
import 'package:flutter_test_demo/views/post/post_detail.dart';
import 'package:flutter_test_demo/views/post/post_list.dart';

class Routes {
  static const String postList = '/';
  static const String postDetail = '/post/detail';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.postList:
        return MaterialPageRoute(
          builder: (_) => const PostList(),
        );
      case Routes.postDetail:
        final postId = int.tryParse(settings.arguments as String);
        return MaterialPageRoute(
          builder: (_) => PostDetail(postId: postId!),
        );
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
  }
}
