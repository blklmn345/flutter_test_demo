import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_demo/routes/router.dart';
import 'package:flutter_test_demo/utils/boot_manager.dart';
import 'package:flutter_test_demo/views/post/post_list.dart';

void main() async {
  await BootManager.configureDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      home: const PostList(),
    );
  }
}
