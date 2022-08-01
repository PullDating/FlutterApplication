import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/chat.dart';
import 'package:pull_flutter/views/filters.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/login.dart';
import 'package:pull_flutter/views/settings.dart';

import '../views/profile_creation/profile_creation_parent.dart';

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
  GoRoute(
      path: '/filters',
      builder: (BuildContext context, GoRouterState state) =>
          const FilterPage()),
  //TODO add /chat route that goes to the correct chat depending on which user was clicked on on the match list page
  GoRoute(
      path: '/chat/:uuid',
      builder: (BuildContext context, GoRouterState state) {
        final uuid = state.params[
            'uuid']; //this holds the uuid of the person who you are chatting with.
        return ChatPage(
          uuid: (uuid != null) ? uuid : "error",
        );
      }),
];
