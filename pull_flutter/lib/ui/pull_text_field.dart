import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullTextFieldWidget extends StatefulWidget {
  const PullTextFieldWidget(
      {
        Key? key,
        this.titleText = '',
        this.titleTextAlign = TextAlign.center,
        required this.isPassword,
        required this.hintText,
        required this.textController,
        required this.enableSuggestions,
        this.capitalization = TextCapitalization.sentences
      }
  ) : super(key: key);

  final String titleText;
  final TextAlign titleTextAlign;
  final bool isPassword;
  final String hintText;
  final TextEditingController textController;
  final bool enableSuggestions;
  final TextCapitalization capitalization;

  @override
  State<PullTextFieldWidget> createState() => _PullTextFieldWidgetState();
}

class _PullTextFieldWidgetState extends State<PullTextFieldWidget> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: widget.capitalization,
      autocorrect: widget.enableSuggestions,
      enableSuggestions: widget.enableSuggestions,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        contentPadding: EdgeInsets.all(15.0),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.black26),
      ),
      style: TextStyle(color: Colors.black),
    );
  }
}
