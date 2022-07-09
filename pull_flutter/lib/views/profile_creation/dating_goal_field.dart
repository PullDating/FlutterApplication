import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileDatingGoalField extends ConsumerStatefulWidget {
  const ProfileDatingGoalField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileDatingGoalField> createState() =>
      _ProfileDatingGoalFieldState();
}

class _ProfileDatingGoalFieldState
    extends ConsumerState<ProfileDatingGoalField> {
  String? datinggoal;

  void changeRadioButton(String? value) {
    setState(() {
      datinggoal = value;
      if (value != null) {
        ref.read(AccountCreationProvider.notifier).setDatingGoal(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    datinggoal = ref.read(AccountCreationProvider).datinggoal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioListTile<String>(
            title: const Text('Long-term Relationship'),
            value: 'ltr',
            groupValue: datinggoal,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Short-term Relationship'),
            value: 'str',
            groupValue: datinggoal,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Hookup'),
            value: 'hookup',
            groupValue: datinggoal,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Just Chatting'),
            value: 'chatting',
            groupValue: datinggoal,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Figuring out what I want'),
            value: 'unsure',
            groupValue: datinggoal,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
        ],
      ),
    );
  }
}
