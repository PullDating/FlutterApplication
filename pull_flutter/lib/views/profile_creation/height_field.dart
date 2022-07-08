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
    // TODO: implement initState
    super.initState();
    height = ref.read(AccountCreationProvider.notifier).getHeight();
    if (height == null) {
      height = (maxHeight + minHeight)/2;
      feet = (height! ~/ 30.48);
      inches = (((height! / 30.48) - (height! ~/ 30.48)) * 12).toInt();
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
                    feet = (height! ~/ 30.48);
                    inches =
                        (((height! / 30.48) - (height! ~/ 30.48)) * 12).toInt();
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
