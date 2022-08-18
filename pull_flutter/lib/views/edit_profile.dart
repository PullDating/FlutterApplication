import 'package:flutter/material.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/profile_creation/photo_field.dart';

//TODO modify this in order to get the stored profile instead of database access.
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late Profile profile = Profile();

  //display variables:
  bool edit = true; //true for edit mode, false for preview mode.

  @override
  void initState() {
    // TODO: implement initState
    //TODO get the profile information from the backend.
    initialize();
    super.initState();
  }

  //get the information from the database, and write it to profile.
  initialize() {

  }

  //they it should update the database, and then navigate back to /home/profile.
  Future<void> submit() async {

  }

  //I want it to have two sides: One that is the edit, and the other that is preview
  //the person should be able to swap back and forth between them at will
  //they should be able to save from either.
  @override
  Widget build(BuildContext context) {

    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom  - kTextTabBarHeight;

    return Material(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: "Edit",),
                    Tab(text: "Preview",),
                  ],
                ),
                //this contains the update two tabs and all the logic
                Container(
                  height: availableHeight*0.9,
                  child: TabBarView(
                    children: [
                      //edit
                      Container(
                        child: Column(
                          children: [
                            ProfilePhotoField(),
                          ],
                        ),
                      ),
                      //preview
                      Container(color: Colors.orange,),
                    ],
                  ),
                ),
                //this serves as a bottom app bar for saving or cancelling.
                Container(
                  color: Colors.lightBlueAccent,
                  height: availableHeight*0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => {print("cancelling profile update")},
                      ),
                      IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () => {print("updating profile")},
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
