import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class ProfileGenderField extends ConsumerStatefulWidget {
  const ProfileGenderField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileGenderField> createState() => _ProfileGenderFieldState();
}

class _ProfileGenderFieldState extends ConsumerState<ProfileGenderField> {
  String? gender;

  void changeRadioButton(String? value) {
    print("gender radio button pressed");
    setState(() {
      if(value != null){
        ref.read(AccountCreationProvider.notifier).setGender(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //gender = ref.read(AccountCreationProvider).gender;
  }

  @override
  Widget build(BuildContext context) {

    gender = ref.watch(AccountCreationProvider).gender;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioListTile<String>(
          title: const Text('Man'),
          value: 'man',
          groupValue: gender,
          onChanged: (String? value) {
            changeRadioButton(value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Woman'),
          value: 'woman',
          groupValue: gender,
          onChanged: (String? value) {
            changeRadioButton(value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Non-Binary'),
          value: 'non-binary',
          groupValue: gender,
          onChanged: (String? value) {
            changeRadioButton(value);
          },
        ),
      ],
    );
  }
}
