import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileHeightField extends ConsumerStatefulWidget {
  const ProfileHeightField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileHeightField> createState() => _ProfileHeightFieldState();
}

class _ProfileHeightFieldState extends ConsumerState<ProfileHeightField> {
  double? height = 0;
  int? feet;
  int? inches = 0;
  final double maxHeight = 275;
  final double minHeight = 55;

  @override
  void initState() {
    super.initState();
    height = ref.read(AccountCreationProvider.notifier).getHeight();
    if (height == null) {
      height = (maxHeight + minHeight)/2;
      List<int> result = cmToFootAndInch(height!);
      feet = result[0];
      inches = result[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${feet}\' ${(inches! < 10) ? '0' : ''}${inches}\""),
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                min: minHeight,
                max: maxHeight,
                divisions: maxHeight.toInt() - minHeight.toInt(),
                value: (height == null) ? (maxHeight + minHeight)/2 : height!,
                onChanged: (value) {
                  setState(() {
                    height = value;
                    List<int> result = cmToFootAndInch(height!);
                    feet = result[0];
                    inches = result[1];
                    ref.read(AccountCreationProvider.notifier).setHeight(value);
                    print("$feet $inches");
                  });
                },
              ),
            ),
            Text(
                '${(height! < 100) ? '0' : ''}${height!.toStringAsFixed(1)} cm'),
          ],
        ));
  }
}

///This function takes in the height of the person in cm, and returns their height
///in feet and inches, as a list where the first item is the feet and the second
/// in inches. both integers.
List<int> cmToFootAndInch(double height) {
  int feet = (height ~/ 30.48);
  int inches = (((height / 30.48) - feet) * 12).toInt();
  return [feet,inches];
}