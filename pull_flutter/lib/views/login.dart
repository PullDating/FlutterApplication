import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneFieldController = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/decorations/loginbackground.png"),
                fit: BoxFit.cover),
          ),
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Phone"),
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('+'),
                          ),
                        )),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 25)),
                  ElevatedButton(
                      onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OTPScreen(phoneFieldController.text, '/home/cards'))
                          );
                      },
                      child: const Text("Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
