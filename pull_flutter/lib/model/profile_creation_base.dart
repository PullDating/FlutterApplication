import 'package:flutter/material.dart';

class ProfileCreationTemplate extends StatelessWidget {
  const ProfileCreationTemplate({
    Key? key,
    required this.title,
    required this.entryField,
    required this.onNext,
    this.isLast,
  }) : super(key: key);

  final String title;
  final Widget entryField;
  final VoidCallback onNext;
  final bool? isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            height: 50,
          ),
          Text(title),
          const Spacer(
            flex: 3,
          ),
          Center(
            child: entryField,
          ),
          const Spacer(
            flex: 3,
          ),
          ElevatedButton(
            onPressed: onNext,
            child: (isLast != null && isLast == true)
                ? const Icon(Icons.check)
                : const Icon(Icons.navigate_next),
          ),
          Container(
            height: 10,
          )
        ]
      ),
    );
  }
}