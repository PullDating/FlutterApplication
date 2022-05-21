import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Box>>(settingsFutureProvider, (previous, next) {
      final storedAuthToken = ref.watch(storedAuthTokenProvider);
      next.whenData((value) => context.go(storedAuthToken == null ? '/login' : '/home'));
    });
    return const Material(child: Center(child: CircularProgressIndicator()));
  }
}
