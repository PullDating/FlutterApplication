import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/analytics.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/login.dart';
import 'package:pull_flutter/views/settings.dart';

import '../views/profileCreation/profileCreationParent.dart';

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

  /// The homepage route has its own sub-routes for different pages accessed via bottom nav bar
  GoRoute(
    path: '/home/:page',
    builder: (BuildContext context, GoRouterState state) {
      final page = state.params['page']!;
      return PullHomePage(title: 'Pull', path: page);
    },
  ),

  /// The homepage route has its own sub-routes for different pages accessed via bottom nav bar
  GoRoute(
    path: '/createProfile/:page',
    builder: (BuildContext context, GoRouterState state) {
      final page = state.params['page']!;
      return ProfileCreationParent(title: 'Pull', path: page);
    },
  ),
  GoRoute(path: '/settings', builder: (BuildContext context, GoRouterState state) => const SettingsPage()),
  GoRoute(path: '/analytics', builder: (BuildContext context, GoRouterState state) => const AnalyticsPage()),

];
