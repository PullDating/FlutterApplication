import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_flutter/ui/pull_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({Key? key}) : super(key: key);

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            //width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: PullTextFieldWidget(
              enableSuggestions: false,
              capitalization: TextCapitalization.words,
              isPassword: false,
              hintText: "what's your name?",
              textController: _nameController,
            ),
          ),
        ),
      ),
    );
  }
}