import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/routes.dart';

updateFilters(BuildContext context){
  print("updating the filters!!!");
  context.go('/home/profile');
}

cancelUpdateFilters(BuildContext context){
  print("Cancelling update filters");
  context.go('/home/profile');
}

/// Tab displaying a list of all of your matches/conversations
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  //they should be allowed to update their filters, and they should be able to cancel.



  final FilterPageInput filterinput = const FilterPageInput(updateFilters, true, cancelUpdateFilters);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //function to update the filters of the user.




    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile_1.webp'),
                  radius: 100,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () {},
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
                  onPressed: () {},
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
