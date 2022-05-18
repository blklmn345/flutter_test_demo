import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_demo/model/response/post.dart';
import 'package:flutter_test_demo/repository/post_repository.dart';
import 'package:flutter_test_demo/services/api_client.dart';
import 'package:flutter_test_demo/utils/datetime_util.dart';
import 'package:flutter_test_demo/utils/degree_util.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  _UnitTests.start();
  _ApiTest.start();
}

class _UnitTests {
  static void start() {
    group('[DegreeUtils]', () {
      test('degree/radian convert test', () {
        const double degree = 180.0;

        final double radian = DegreeUtil.deg2rad(degree);

        final double degree2 = DegreeUtil.rad2deg(radian);

        expect(radian, pi);

        expect(degree2, degree);
      });
    });

    group('[DateTimeUtils]', () {
      test('date between', () {
        final now = DateTime.now();

        DateTime start = now.subtract(const Duration(days: 1));
        DateTime end = now.add(const Duration(days: 1));

        final isBetween = now.isBetween(start, end);

        expect(isBetween, true);

        start = now;
        end = now;

        expect(now.isBetween(start, end), false);
        expect(now.isBetweenOrEqual(start, end), true);

        expect(DateTimeUtil.monthsBetween(start, end), 0);

        start = DateTime(2022, 1, 1);
        end = DateTime(2022, 2, 31);
        expect(DateTimeUtil.monthsBetween(start, end), 2);

        start = DateTime(2021, 12, 1);
        end = DateTime(2022, 8, 1);
        expect(DateTimeUtil.monthsBetween(start, end), 8);
      });
    });
  }
}

class _ApiTest {
  static void start() {
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet('https://jsonplaceholder.typicode.com/posts', (server) {
      server.reply(
        200,
        [Post(userId: 1, id: 1, title: 'title', body: 'body').toJson()],
      );
    });

    dioAdapter.onGet('https://jsonplaceholder.typicode.com/posts/2', (server) {
      server.reply(
        200,
        Post(userId: 2, id: 2, title: 'title2', body: 'body2').toJson(),
      );
    });

    dioAdapter.onGet('https://jsonplaceholder.typicode.com/posts/3', (server) {
      server.reply(
        200,
        null,
      );
    });

    group('[Api]', () {
      test('Get posts', () => _getPosts(dio));
      test('Post providers', () => _postProvider(dio));
    });
  }

  static void _getPosts(Dio dio) async {
    final repo = PostRepository(ApiClient.mock(dio));
    final posts = await repo.getPosts();

    expect(posts.length, 1);
    expect(posts[0].body, 'body');

    final post = await repo.getPost(2);

    expect(
      post,
      isA<Post>()
          .having((p0) => p0.id, 'id', 2)
          .having((p0) => p0.title, 'title', 'title2'),
    );

    final nullPost = await repo.getPost(3);
    expect(nullPost, null);
  }

  static void _postProvider(Dio dio) async {
    final container = ProviderContainer(
      overrides: [
        postsRepoProvider.overrideWithValue(
          PostRepository(ApiClient.mock(dio)),
        ),
        postListProvider.overrideWithValue(
          AsyncValue.data(
            [Post(id: 1, title: 'title', body: 'body', userId: 1)],
          ),
        ),
        postDetailProvider(2).overrideWithValue(
          AsyncValue.data(
            Post(id: 2, title: 'title2', body: 'body2', userId: 2),
          ),
        ),
      ],
    );

    final postList = await container.read(postsRepoProvider).getPosts();
    expect(postList.length, 1);

    expect(container.read(postListProvider).asData!.value, [
      isA<Post>()
          .having((p0) => p0.id, 'id', 1)
          .having((p0) => p0.title, 'title', 'title')
    ]);
    expect(
        container.read(postDetailProvider(2)).asData!.value,
        isA<Post>()
            .having((p0) => p0.id, 'id', 2)
            .having((p0) => p0.body, 'body', 'body2'));

    final nullDio = Dio();
    final nullAdapter = DioAdapter(dio: nullDio);
    nullAdapter.onGet('https://jsonplaceholder.typicode.com/posts', (server) {
      server.reply(200, null);
    });
    nullAdapter.onGet('https://jsonplaceholder.typicode.com/posts/2', (server) {
      server.reply(200, null);
    });

    final nullContainer = ProviderContainer(overrides: [
      postsRepoProvider.overrideWithValue(PostRepository(
        ApiClient.mock(nullDio),
      ))
    ]);
    expect(await nullContainer.read(postsRepoProvider).getPosts(), []);
    expect(nullContainer.read(postListProvider).asData?.value, null);
    expect(nullContainer.read(postDetailProvider(2)).asData?.value, null);

    final realClient = ApiClient.instance;
    expect(realClient, isNotNull);

    final realRepoContainer = ProviderContainer(
      overrides: [postsRepoProvider],
    );
    expect(realRepoContainer.read(postsRepoProvider), isNotNull);
  }
}
