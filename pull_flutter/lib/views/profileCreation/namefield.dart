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
    myData = ref.watch(accountCreationProfile).name;
    ref.read(accountCreationProfile);
    final TextEditingController _nameController = TextEditingController();
    _updateName() {
      log("Second text field: ${_nameController.text}");
      ref.read(accountCreationProfile).copyWith(name: _nameController.text);
      print(ref.read(accountCreationProfile).toString());
    }

    //final TextEditingController _nameController = TextEditingController();
    _nameController.addListener(() {
      _updateName();
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
                    ref.read(accountCreationProfile).copyWith(name: "jeff");
                    print(ref.read(accountCreationProfile).toString());
                  },
                child: Text((myData == null)? myData! : "hello"),
              )
            ],
          )
        ),
      ),
    );
  }
}
