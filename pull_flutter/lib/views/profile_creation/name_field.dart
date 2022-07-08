import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pull_common/src/model/provider/create_account.dart';
import 'package:pull_common/src/model/entity/profile.dart';

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
    Profile myData = ref.watch(AccountCreationProvider);
    //this value lags behind the actual riverpod instance, when I use setters and getters
    //I get the correct value. I don't know how good this is to use.

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
