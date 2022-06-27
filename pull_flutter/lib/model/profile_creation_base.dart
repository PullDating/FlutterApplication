import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileCreationTemplate extends ConsumerStatefulWidget {
  const ProfileCreationTemplate({
    Key? key,
    required this.title,
    required this.entryField,
    required this.nextfunction,
    this.isLast,
  }) : super(key: key);

  final String title;
  final Widget entryField;
  final VoidCallback nextfunction;
  final bool? isLast;

  @override
  ConsumerState <ProfileCreationTemplate> createState() => _ProfileCreationTemplateState();
}

class _ProfileCreationTemplateState extends ConsumerState<ProfileCreationTemplate> {
  @override
  void initState() {
    super.initState();
    final profile = ref.read(accountCreationProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountCreationProvider);
    return Material(
      child: Column(
        children: [
          Container(height: 50,),
          Text(widget.title),
          Spacer(flex: 3,),
          Center(
            child: widget.entryField,
          ),
          Spacer(flex: 3,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlueAccent,
              shape: StadiumBorder(),
            ),
            onPressed: widget.nextfunction, child: (widget.isLast != null && widget.isLast == true)? Icon(Icons.check) : Icon(Icons.navigate_next),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("hello");
  }
}