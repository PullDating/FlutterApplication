import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/loading.dart';
import 'package:pull_flutter/views/login.dart';

final appRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) => const LoadingPage(),
  ),
  GoRoute(
    path: '/login',
    builder: (BuildContext context, GoRouterState state) => const LoginPage(),
  ),
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) => const PullHomePage(title: 'Pull'),
  ),
];
