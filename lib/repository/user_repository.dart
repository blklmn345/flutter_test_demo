import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/model/response/user.dart';
import 'package:flutter_test_demo/repository/repository_base.dart';
import 'package:flutter_test_demo/services/api_client.dart';

final userRepoProvider = Provider.autoDispose(
  (_) => UserRepository(ApiClient.instance),
);
final usersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(userRepoProvider).getUsers(),
);
final userProvider = FutureProvider.autoDispose.family<User?, int>(
  (ref, id) => ref.watch(userRepoProvider).getUser(id),
);

class UserRepository extends RepositoryBase {
  UserRepository(super.client);

  Future<List<User>> getUsers() async {
    final res = await client.get('https://jsonplaceholder.typicode.com/users');
    final json = jsonDecode(res.data ?? '');
    if (json == null || json.isEmpty == true) {
      return [];
    }
    return (json as List<dynamic>)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<User?> getUser(int id) async {
    final res =
        await client.get('https://jsonplaceholder.typicode.com/users/$id');
    final json = jsonDecode(res.data ?? '');
    if (json == null || json.isEmpty == true) {
      return null;
    }
    return User.fromJson(json as Map<String, dynamic>);
  }
}
