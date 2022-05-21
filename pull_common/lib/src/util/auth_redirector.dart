import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

class AuthRedirector extends ConsumerWidget {
  const AuthRedirector({super.key, this.authUrl = '/login', this.homeUrl = '/home', this.child});

  final String authUrl;
  final String homeUrl;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Box>>(settingsFutureProvider, (previous, next) {
      final storedAuthToken = ref.watch(storedAuthTokenProvider);
      next.whenData((value) => context.go(storedAuthToken == null ? authUrl : homeUrl));
    });
    return Material(child: Center(child: child ?? CircularProgressIndicator()));
  }
}
