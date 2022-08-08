import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

/// Tab displaying a list of all of your matches/conversations
class ChatsTab extends ConsumerWidget {
  const ChatsTab({super.key});

  Future<int> _getLimit() async{
    var box = await Hive.openBox(kSettingsBox);
    return box.get('concurrentMatchLimit');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Material(
      child: FutureBuilder<int>(
        future: _getLimit(),
        builder: (BuildContext context, AsyncSnapshot<int> limit) {
          return ListView(

            children: [
              //TODO modify this so that it gets the number of chats from the server. (or for testing a preset list)
              for (var i = 0; i < ((limit.hasData)? limit.data! : 0); i++)
                InkWell(
                  onTap: () {
                    ///TODO go to the corresponding chat.
                    context.go('/chat/$i');
                  },
                  child: ListTile(
                    title: Text("Person $i"),
                    subtitle: const Text("You: Most recent text"),
                    trailing: const Text("Time"),
                    leading: CircleAvatar(
                      child: Text(i.toString()),
                    ),
                  ),
                )
            ],
          );
        }
      ),
    );
  }
}
