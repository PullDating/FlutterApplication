import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class ProfileBodyTypeField extends ConsumerStatefulWidget {
  const ProfileBodyTypeField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileBodyTypeField> createState() =>
      _ProfileBodyTypeFieldState();
}

class _ProfileBodyTypeFieldState extends ConsumerState<ProfileBodyTypeField> {
  String? bodytype;

  void changeRadioButton(String? value) {
    setState(() {
      bodytype = value;
      if (value != null) {
        ref.read(AccountCreationProvider.notifier).setBodyType(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bodytype = ref.read(AccountCreationProvider).bodytype;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioListTile<String>(
            title: const Text('Obese'),
            value: 'obese',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Heavy'),
            value: 'heavy',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Muscular'),
            value: 'muscular',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Average'),
            value: 'average',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Lean'),
            value: 'lean',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
        ],
      ),
    );
  }
}
