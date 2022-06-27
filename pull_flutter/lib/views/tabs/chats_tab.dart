import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tab displaying a list of all of your matches/conversations
class ChatsTab extends ConsumerWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: ListView(
        children: [
          //TODO modify this so that it gets the number of chats from the server. (or for testing a preset list)
          for (var i = 0; i < 10; i++)
            InkWell(
              onTap: () {
                ///TODO go to the corresponding chat.
                context.go('/chat/${i}');
              },
              child: ListTile(
                title: Text("Person $i"),
                subtitle: Text("You: Most recent text"),
                trailing: Text("Time"),
                leading: CircleAvatar(
                  child: Text(i.toString()),
                ),
              ),
            )
        ],
      ),
    );
  }
}
