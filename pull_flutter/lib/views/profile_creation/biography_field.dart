import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/pull_common.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileBiographyField extends ConsumerStatefulWidget {
  const ProfileBiographyField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileBiographyField> createState() =>
      _ProfileBiographyFieldState();
}

class _ProfileBiographyFieldState extends ConsumerState<ProfileBiographyField> {
  late TextEditingController _controller;
  String? biography;
  final int maxCharacters = 300;
  int numCharacters = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    biography = ref.read(AccountCreationProvider).biography;
    _controller.text = (biography == null) ? '' : biography!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Container(
        child: Column(
          children: [
            TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxCharacters),
              ],
              minLines: 1,
              maxLines: 5,
              obscureText: false,
              controller: _controller,
              onChanged: (String value) {
                setState(() {
                  biography = value;
                  ref.read(AccountCreationProvider.notifier).setBiography(value);
                  numCharacters = _controller.text.characters.length;
                  print("Current number of characters: $numCharacters");
                });
              },
            ),
            Text(
              (numCharacters >= 300)
                  ? "Max Characters Reached!"
                  : "$numCharacters/$maxCharacters",
              style: TextStyle(
                color:
                    (numCharacters >= 300) ? Theme.of(context).colorScheme.secondary : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
