import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final natState = ref.watch(networkAuthTokenProvider.state);
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 36.0),
          child: Column(
            children: [
              const Text("Login"),
              ElevatedButton(
                  onPressed: () {
                    settings!.put(kSettingsApiToken, natState.state = 'demo token');
                    //context.go('/home/cards');
                    context.go('/createProfile/name');
                  },
                  child: const Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
