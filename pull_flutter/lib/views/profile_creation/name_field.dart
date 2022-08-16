import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class ProfileNameField extends ConsumerStatefulWidget {
  const ProfileNameField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileNameField> createState() => _ProfileNameFieldState();
}

class _ProfileNameFieldState extends ConsumerState<ProfileNameField> {
  final TextEditingController _nameController = TextEditingController();
  String? myData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? initial = ref.read(AccountCreationProvider.notifier).getName();
    _nameController.text = (initial == null) ? '' : initial;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
            //width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  onChanged: (text) {
                    ref.read(AccountCreationProvider.notifier).setName(text);
                  },
                ),
              ],
            )),
      ),
    );
  }
}
