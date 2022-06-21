import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/login.dart';
import 'package:pull_flutter/views/profileCreation/add_photos.dart';
import 'package:pull_flutter/views/settings.dart';

import '../views/profileCreation/profile_creation_parent.dart';

final appRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) =>
        const AuthRedirector(
      //homeUrl: '/home/cards',
          homeUrl: '/login',
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
  GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsPage()),
];
