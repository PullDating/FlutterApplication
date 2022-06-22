import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pull_common/src/model/provider/create_account.dart';
import 'package:pull_common/src/model/entity/profile.dart';


class ProfileNameField extends ConsumerStatefulWidget {
  const ProfileNameField({Key? key}) : super(key: key);

  @override
  ConsumerState <ProfileNameField> createState() => _ProfileNameFieldState();
}

class _ProfileNameFieldState extends ConsumerState <ProfileNameField> {

  String? myData;

  @override
  Widget build(BuildContext context) {
    Profile myData = ref.watch(accountCreationProvider);
    final TextEditingController _nameController = TextEditingController();
  _nameController.text = (myData.name == Null) ? myData.name! : '';
    //final TextEditingController _nameController = TextEditingController();
    _nameController.addListener(() {

    });



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
              ),
              ElevatedButton(
                  onPressed: () {
                    print("button pressed");
                    ref.read(accountCreationProvider.notifier).setName("jeff");
                    print(myData.name);
                    _nameController.text = myData.name!;
                  },
                child: Text('hello there general kenobi'),
              )
            ],
          )
        ),
      ),
    );
  }
}
