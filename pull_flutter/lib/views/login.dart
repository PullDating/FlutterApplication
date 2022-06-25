import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    final phoneFieldController = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 36.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Pull",
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                      controller: phoneFieldController,
                      decoration: const InputDecoration(
                        label: Text("Phone"),
                      )),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 25)),
                ElevatedButton(
                    onPressed: () async {
                      final router = GoRouter.of(context);
                      final authResult = await repository.authenticate(AuthRequest.phone(phoneFieldController.text));

                      /* if (!authResult.userExists) {
                        router.go('/createAccount/add_photos');
                        return;
                      }*/

                      router.go('/home/cards');
                    },
                    child: const Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
