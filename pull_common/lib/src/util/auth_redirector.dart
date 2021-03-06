import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

/// A widget that automatically redirects to the login page if the locally stored authentication token is not present
/// (i.e the user is not logged in), otherwise automatically redirects to the home page
class AuthRedirector extends ConsumerWidget {
  const AuthRedirector({super.key, this.authUrl = '/login', this.homeUrl = '/home', this.child});

  final String authUrl;
  final String homeUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wait for the local settings data to be available
    ref.listen<AsyncValue<Box>>(settingsFutureProvider, (previous, next) {
      // Navigate based on the presence of the stored auth token
      next.whenData((value) => context.go(value.get(kSettingsApiToken) == null ? authUrl : homeUrl));
    });
    return Material(child: Center(child: child ?? CircularProgressIndicator()));
  }
}
