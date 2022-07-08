import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

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
    // TODO: implement initState
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
            title: const Text('HeavySet'),
            value: 'HeavySet',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Stocky'),
            value: 'Stocky',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('A Few Extra Pounds'),
            value: 'AFewExtraPounds',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Average'),
            value: 'Average',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Athletic'),
            value: 'Athletic',
            groupValue: bodytype,
            onChanged: (String? value) {
              changeRadioButton(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Slender'),
            value: 'Slender',
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
