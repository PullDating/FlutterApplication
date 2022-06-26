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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    height = ref.read(accountCreationProvider.notifier).getHeight();
    if(height == null){
      height = 165;
      feet = (height!~/30.48);
      inches = (((height! / 30.48)-(height! ~/ 30.48))*12).toInt();
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
          Text("${feet}\' ${(inches! < 10)? '0' : ''}${inches}\""),
          RotatedBox(
            quarterTurns: 3,
            child: Slider(
              min: 55,
              max: 275,
              divisions: 100,
              value: (height == null)? 165 : height!,
              onChanged: (value) {
                setState(() {
                  height = value;
                  feet = (height!~/30.48);
                  inches = (((height! / 30.48)-(height! ~/ 30.48))*12).toInt();
                  ref.read(accountCreationProvider.notifier).setHeight(value);
                  print("${feet} ${inches}");
                });
              },
            ),
          ),
          Text('${(height! < 100)? '0':''}${height!.toStringAsFixed(1)} cm'),
        ],
      )
    );
  }
}
