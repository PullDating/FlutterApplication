import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileGenderField extends ConsumerStatefulWidget {
  const ProfileGenderField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileGenderField> createState() => _ProfileGenderFieldState();
}

class _ProfileGenderFieldState extends ConsumerState<ProfileGenderField> {
  String? gender;

  void changeRadioButton(String? value) {
    setState(() {
      gender = value;
      if (value != null) {
        ref.read(AccountCreationProvider.notifier).setGender(value);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gender = ref.read(AccountCreationProvider).gender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: gender,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: gender,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Non Binary'),
            value: 'Non Binary',
            groupValue: gender,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
        ],
      ),
    );
  }
}
