import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsTab extends ConsumerWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        for (var i = 0; i < 10; i++)
          ListTile(
            title: Text("Person $i"),
            leading: CircleAvatar(
              child: Text(i.toString()),
            ),
          )
      ],
    );
  }
}
