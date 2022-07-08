import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileBirthDateField extends ConsumerStatefulWidget {
  const ProfileBirthDateField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileBirthDateField> createState() =>
      _ProfileBirthDateFieldState();
}

class _ProfileBirthDateFieldState extends ConsumerState<ProfileBirthDateField> {
  DateTime? birthdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    birthdate = ref.read(AccountCreationProvider.notifier).getBirthDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: (birthdate == null) ? DateTime.now() : birthdate,
          onDateTimeChanged: (val) {
            birthdate = val;
            ref
                .watch(AccountCreationProvider.notifier)
                .setBirthDate(birthdate!);
          }),
    );
  }
}
