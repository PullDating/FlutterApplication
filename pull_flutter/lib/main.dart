import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_flutter/model/routes.dart';
import 'package:pull_flutter/model/settings.dart';

void main() {
  runApp(ProviderScope(child: PullApp()));
}

class PullApp extends HookConsumerWidget {
  PullApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(routes: appRoutes);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useDarkTheme = ref.watch(useDarkThemeProvider);

    return MaterialApp.router(
      title: 'Pull',
      theme: ThemeData(
        brightness: useDarkTheme ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
