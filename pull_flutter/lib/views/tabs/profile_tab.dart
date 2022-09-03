import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';

import '../../model/routes.dart';

updateFilters(BuildContext context, WidgetRef ref, Filters filters) async {
  print("updating the filters!!!");
  try{
    PullRepository repo = PullRepository(ref.read);
    await repo.updateFilterRequest(filters);
    context.go('/home/cards');
  }catch (e){
    print("There was an error somewhere in the profile creation.");
    print(e);
    return;
  }
  context.go('/home/profile');
}

cancelUpdateFilters(BuildContext context){
  print("Cancelling update filters");
  context.go('/home/profile');
}


class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}


/// Tab displaying a list of all of your matches/conversations
class _ProfileTabState extends ConsumerState <ProfileTab> {
  //they should be allowed to update their filters, and they should be able to cancel.


  //get the most recent filters of the user
  //TODO modify this function to be cached after login
  @override
  void initState () {
    super.initState();
    try {
      PullRepository repo = PullRepository(ref.read);
      profileGet = repo.getFirstPhoto(null);
    } catch (e){
      print(e);
    }
    print("init state in the profile page.");
  }

  final FilterPageInput filterinput = const FilterPageInput(updateFilters, true, cancelUpdateFilters);

  late Future<String> profileGet;

  @override
  Widget build(BuildContext context) {

    //function to update the filters of the user.

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                FutureBuilder(
                  future: profileGet,
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          radius: 100,
                        );
                      } else {
                        throw Exception("No profile image was returned.");
                        return CircularProgressIndicator();
                      }
                    }else{
                      return SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                        ),
                      );
                    }
                  }
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO add functionality to edit the profile.
                      //need to populate the profileprovider for the next page to use.
                      //TODO create populateProfile()
                      //populateProfile();
                      context.go('/profile/edit');
                    },
                    child: Icon(Icons.edit, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Colors.blue, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push('/settings');
                  },
                  child: Icon(Icons.settings, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.blue, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/filters',extra: filterinput);
                  },
                  child: Icon(Icons.filter_list_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.blue, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
