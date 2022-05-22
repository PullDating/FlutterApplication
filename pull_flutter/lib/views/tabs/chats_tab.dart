import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tab displaying a list of all of your matches/conversations
class ChatsTab extends ConsumerWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: ListView(
        children: [
          for (var i = 0; i < 10; i++)
            ListTile(
              title: Text("Person $i"),
              leading: CircleAvatar(
                child: Text(i.toString()),
              ),
            )
        ],
      ),
    );
  }
}
