import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/chat.dart';
import 'package:pull_flutter/views/filters.dart';
import 'package:pull_flutter/views/home.dart';
import 'package:pull_flutter/views/login.dart';
import 'package:pull_flutter/views/settings.dart';

import '../development_utils/devLogin.dart';
import '../views/edit_profile.dart';
import '../views/profile_creation/profile_creation_parent.dart';

final appRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) =>
        const AuthRedirector(
      authUrl: '/login',
      homeUrl: '/home/cards',
      devUrl: '/devlogin', //comment out for production
      dev: false, //comment out for production.
    ),
  ),

  //this route is just for developers to be able to get around the login mechanics if they aren't working on that part.
  //comment out before production.
  GoRoute(
    path: '/devlogin',
    builder: (BuildContext context, GoRouterState state) => const DevLogin(),
  ),

  GoRoute(
    path: '/login',
    builder: (BuildContext context, GoRouterState state) => LoginPage(),
  ),

  GoRoute(
    path: '/login/sms/:verificationId',
    builder: (BuildContext context, GoRouterState state) {
      final verificationId = state.params['verificationId']!;
      return OTPScreen(verificationId: verificationId, phone: state.extra! as PhoneNumber);
    },
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
    path: '/profile/edit',
    builder: (BuildContext context, GoRouterState state) {
      return const EditProfile();
    },
  ),

  GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsPage()),
  GoRoute(
      path: '/filters',
      builder: (BuildContext context, GoRouterState state) {
        final FilterPageInput input = state.extra! as FilterPageInput;
        return FilterPage(onDone: input.onDone, cancelable: input.cancelable,onCancel: input.onCancel);
      }

  ),
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

class FilterPageInput {
  final Function onDone;
  final bool cancelable;
  final Function? onCancel;
  const FilterPageInput(this.onDone, this.cancelable, this.onCancel);
}