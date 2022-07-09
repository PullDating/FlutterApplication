import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart' show CupertinoDatePicker, CupertinoDatePickerMode;
import 'package:pull_common/pull_common.dart';

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
    super.initState();
    birthdate = ref.read(AccountCreationProvider.notifier).getBirthDate();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
