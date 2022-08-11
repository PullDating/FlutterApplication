import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pull_common/pull_common.dart';

class MatchDisplayInformation{
  const MatchDisplayInformation({
    required this.name,
    required this.mostRecentTextString,
    required this.mostRecentTextTime,
    required this.profileImage,

  });

  final String name;
  final String mostRecentTextString;
  final String mostRecentTextTime;
  final String profileImage;
}

/// Tab displaying a list of all of your matches/conversations
class ChatsTab extends ConsumerWidget {
  const ChatsTab({super.key});

  Future<int> _getLimit() async{
    var box = await Hive.openBox(kSettingsBox);
    return box.get('concurrentMatchLimit');
  }

  Future<List<MatchDisplayInformation>> _getMatchInformation(WidgetRef ref) async {
    //call the get/matches endpoint to return the uuids of the matches.
    try{
      PullRepository repo = PullRepository(ref.read);

      List<String> matches = await repo.getMatches();
      List<MatchDisplayInformation> l = [];
      // var formatter = new DateFormat('yy-MM-dd hh:mm:ss');
      // var now = new DateTime.now();
      // String formattedDate = formatter.format(now);
      for(String match in matches){
        Map<String,dynamic> profile = await repo.getProfile();
        print(profile);
        //TODO poll the chats for the most recent chat text and time and display them here
        l.add(new MatchDisplayInformation(name: profile['name'], mostRecentTextString: "This is a placeholder", mostRecentTextTime: DateFormat('yyyy-MM-dd kk:mm a').format(DateTime.now()), profileImage: profile['imagePath']['0'] ));
        //l.add(new MatchDisplayInformation(name: "placeholder name", mostRecentTextString: "This is a placeholder", mostRecentTextTime: DateFormat('yyyy-MM-dd kk:mm a').format(DateTime.now()), profileImage: Image.asset('assets/images/profile_1.webp') ));
      }
      return l;
    }catch (e){
      print("There was an error getting the match information.");
      print(e);
      throw Exception("There was an error getting the match information");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Material(
      child: FutureBuilder<List<MatchDisplayInformation>>(
        future: _getMatchInformation(ref),
        //future: _getLimit(),
        builder: (BuildContext context, AsyncSnapshot<List<MatchDisplayInformation>> matches) {
          return ListView(

            children: [
              for (var i = 0; i < ((matches.hasData)? matches.data!.length : 0); i++)
                InkWell(
                  onTap: () {
                    ///TODO go to the corresponding chat.
                    context.go('/chat/$i');
                  },
                  child: ListTile(
                    title: Text(matches.data![i].name),
                    subtitle: Text(matches.data![i].mostRecentTextString),
                    trailing: Text(matches.data![i].mostRecentTextTime.toString()),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(matches.data![i].profileImage),
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
