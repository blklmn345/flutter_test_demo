import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_demo/model/response/post.dart';
import 'package:flutter_test_demo/model/response/user.dart';
import 'package:flutter_test_demo/repository/post_repository.dart';
import 'package:flutter_test_demo/repository/user_repository.dart';
import 'package:flutter_test_demo/services/api_client.dart';
import 'package:flutter_test_demo/utils/datetime_util.dart';
import 'package:flutter_test_demo/utils/degree_util.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  _UtilTests.start();
  _ApiTest.start();
}

class _UtilTests {
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
    group('[Api]', () {
      test('Get posts', () => _getPosts());
      test('Get users', () => _getUsers());
      test('Get user', () => _getUser());
    });

    group('[Api Providers]', () {
      test('Post providers', () => _postProviders());
      test('User providers', () => _userProviders());
    });
  }

  static void _getPosts() async {
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

  static void _postProviders() async {
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

  static _getUsers() async {
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet('https://jsonplaceholder.typicode.com/users', (server) {
      server.reply(200, [
        User(
                id: 1,
                name: 'name',
                username: 'username',
                address: Address(
                    street: 'street',
                    suite: 'suite',
                    city: 'city',
                    zipcode: 'zipcode',
                    geo: Geo(lat: 'lat', lng: 'lng')),
                company:
                    Company(bs: 'bs', name: 'name', catchPhrase: 'catchPhrase'),
                email: 'email',
                phone: 'phone',
                website: 'website')
            .toJson()
      ]);
    });

    final users = await UserRepository(ApiClient.mock(dio)).getUsers();
    expect(users.length, 1);
    expect(
        users[0],
        isA<User>()
            .having((p0) => p0.id, 'id', 1)
            .having((p0) => p0.address.street, 'street', 'street')
            .having((p0) => p0.company.bs, 'bs', 'bs'));

    final nullAdapter = DioAdapter(dio: dio);

    nullAdapter.onGet('https://jsonplaceholder.typicode.com/users', (server) {
      server.reply(200, null);
    });

    final nullUsers = await UserRepository(ApiClient.mock(dio)).getUsers();
    expect(nullUsers, []);
  }

  static _getUser() async {
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);

    dioAdapter.onGet('https://jsonplaceholder.typicode.com/users/2', (server) {
      server.reply(
          200,
          User(
                  id: 2,
                  name: 'name',
                  username: 'username',
                  address: Address(
                      street: 'street',
                      suite: 'suite',
                      city: 'city',
                      zipcode: 'zipcode',
                      geo: Geo(lat: 'lat', lng: 'lng')),
                  company: Company(
                      bs: 'bs', name: 'name', catchPhrase: 'catchPhrase'),
                  email: 'email',
                  phone: 'phone',
                  website: 'website')
              .toJson());
    });

    final user = await UserRepository(ApiClient.mock(dio)).getUser(2);
    expect(
        user,
        isA<User>()
            .having((p0) => p0.id, 'id', 2)
            .having((p0) => p0.address.street, 'street', 'street')
            .having((p0) => p0.company.bs, 'bs', 'bs'));

    final nullAdapter = DioAdapter(dio: dio);

    nullAdapter.onGet('https://jsonplaceholder.typicode.com/users/2', (server) {
      server.reply(200, null);
    });

    final nullUser = await UserRepository(ApiClient.mock(dio)).getUser(2);
    expect(nullUser, null);
  }

  static _userProviders() async {
    final dio = Dio();
    final adapter = DioAdapter(dio: dio);

    adapter.onGet('https://jsonplaceholder.typicode.com/users', (server) {
      server.reply(200, [
        User(
                id: 1,
                name: 'name',
                username: 'username',
                address: Address(
                    street: 'street',
                    suite: 'suite',
                    city: 'city',
                    zipcode: 'zipcode',
                    geo: Geo(lat: 'lat', lng: 'lng')),
                company:
                    Company(bs: 'bs', name: 'name', catchPhrase: 'catchPhrase'),
                email: 'email',
                phone: 'phone',
                website: 'website')
            .toJson(),
        User(
                id: 2,
                name: 'name2',
                username: 'username2',
                address: Address(
                    street: 'street2',
                    suite: 'suite2',
                    city: 'city2',
                    zipcode: 'zipcode2',
                    geo: Geo(lat: 'lat2', lng: 'lng2')),
                company: Company(
                    bs: 'bs2', name: 'name2', catchPhrase: 'catchPhrase2'),
                email: 'email2',
                phone: 'phone2',
                website: 'website2')
            .toJson()
      ]);
    });

    final container = ProviderContainer(
      overrides: [
        userRepoProvider.overrideWithValue(UserRepository(ApiClient.mock(dio))),
        userProvider(1).overrideWithValue(AsyncValue.data(User(
            id: 1,
            name: 'name',
            username: 'username',
            address: Address(
                street: 'street',
                suite: 'suite',
                city: 'city',
                zipcode: 'zipcode',
                geo: Geo(lat: 'lat', lng: 'lng')),
            company:
                Company(bs: 'bs', name: 'name', catchPhrase: 'catchPhrase'),
            email: 'email',
            phone: 'phone',
            website: 'website'))),
        usersProvider.overrideWithValue(AsyncValue.data([
          User(
              id: 1,
              name: 'user1',
              username: 'username',
              address: Address(
                  street: 'street',
                  suite: 'suite',
                  city: 'city',
                  zipcode: 'zipcode',
                  geo: Geo(lat: 'lat', lng: 'lng')),
              company:
                  Company(bs: 'bs', name: 'name', catchPhrase: 'catchPhrase'),
              email: 'email',
              phone: 'phone',
              website: 'website')
        ])),
      ],
    );

    expect(container.read(userProvider(1)).asData?.value, isNotNull);
    expect(container.read(userProvider(2)).asData?.value, isNull);
    expect(container.read(usersProvider), isNotNull);
    expect(container.read(usersProvider).asData?.value, isNotNull);
    expect(container.read(usersProvider).asData?.value,
        [isA<User>().having((p0) => p0.name, 'name', 'user1')]);
  }
}
