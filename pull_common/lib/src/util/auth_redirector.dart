import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

/// A widget that automatically redirects to the login page if the locally stored authentication token is not present
/// (i.e the user is not logged in), otherwise automatically redirects to the home page
class AuthRedirector extends ConsumerWidget {
  const AuthRedirector(
      {super.key, this.authUrl = '/login', this.homeUrl = '/home', this.devUrl='/devlogin', this.child, this.dev = false});

  final String authUrl;
  final String homeUrl;
  final String devUrl;
  final Widget? child;
  final bool dev;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      if(dev){
        //developer login path

        context.go(devUrl);
      } else {
        //production login path.

        // Wait for the local settings data to be available
        ref.listen<AsyncValue<Box>>(settingsFutureProvider, (previous, next) {
          // Navigate based on the presence of the stored auth token
          next.whenData((value) =>
              context.go(authUrl));
          //todo switch this back to depend on if there is a user already.
          //context.go(FirebaseAuth.instance.currentUser != null ? homeUrl : authUrl));
        });
      }
    });
    return Material(child: Center(child: child ?? CircularProgressIndicator()));
  }
}
