import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/login.dart';

final appRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) => const AuthRedirector(
      homeUrl: '/home/cards',
    ),
  ),
  GoRoute(
    path: '/login',
    builder: (BuildContext context, GoRouterState state) => const LoginPage(),
  ),
  GoRoute(
    path: '/home/:page',
    builder: (BuildContext context, GoRouterState state) {
      final page = state.params['page']!;
      return PullHomePage(title: 'Pull', path: page);
    },
  ),
];
