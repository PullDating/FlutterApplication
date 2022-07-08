import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileCreationTemplate extends StatelessWidget {
  const ProfileCreationTemplate({
    Key? key,
    required this.title,
    required this.entryField,
    required this.nextFunction,
    this.isLast,
  }) : super(key: key);

  final String title;
  final Widget entryField;
  final VoidCallback nextFunction;
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
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlueAccent,
              shape: const StadiumBorder(),
            ),
            onPressed: nextFunction,
            child: (isLast != null && isLast == true)
                ? const Icon(Icons.check)
                : const Icon(Icons.navigate_next),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}



/*
class ProfileCreationTemplate extends ConsumerStatefulWidget {
  const ProfileCreationTemplate({
    Key? key,
    required this.title,
    required this.entryField,
    required this.nextFunction,
    this.isLast,
  }) : super(key: key);

  final String title;
  final Widget entryField;
  final VoidCallback nextFunction;
  final bool? isLast;

  @override
  ConsumerState<ProfileCreationTemplate> createState() =>
      _ProfileCreationTemplateState();
}

class _ProfileCreationTemplateState
    extends ConsumerState<ProfileCreationTemplate> {
  @override
  void initState() {
    super.initState();
    final profile = ref.read(AccountCreationProvider);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(AccountCreationProvider);
    return Material(
      child: Column(
        children: [
          Container(
            height: 50,
          ),
          Text(widget.title),
          const Spacer(
            flex: 3,
          ),
          Center(
            child: widget.entryField,
          ),
          const Spacer(
            flex: 3,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlueAccent,
              shape: const StadiumBorder(),
            ),
            onPressed: widget.nextFunction,
            child: (widget.isLast != null && widget.isLast == true)
                ? const Icon(Icons.check)
                : const Icon(Icons.navigate_next),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}
*/