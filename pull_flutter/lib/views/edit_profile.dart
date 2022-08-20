import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/profile_creation/photo_field.dart';
import 'package:tuple/tuple.dart';

//TODO modify this in order to get the stored profile instead of database access.
class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {

  late Profile profile = Profile();

  //display variables:
  bool edit = true; //true for edit mode, false for preview mode.

  @override
  void initState() {
    // TODO: implement initState
    //TODO get the profile information from the backend.
    super.initState();
  }

  //get the information from the database, and write it to profile.
  Future<Tuple2<Profile,ProfileImages>> _initialize() async {
    //the defaults if it goes wrong.
    Profile profile = new Profile();
    ProfileImages profileImages = ProfileImages(
      images: [],
      mandatoryFilled: false,
      max: ref.read(ProfilePhotosProvider).max,
      min: ref.read(ProfilePhotosProvider).min,
      numFilled: 0
    );

    //TODO get the profile from the backend via http request, and then return
    //set the accountCreationProvider and the profilePhoto provider.
    //make call to database and in that set the providers, set these afterwards.


    try{
      PullRepository repo = PullRepository(ref.read);
       await repo.getProfile(ref);
       //get the information from the profile providers
      // now update the local copies of everything accordingly
      profileImages = ref.watch(ProfilePhotosProvider);
      profile = ref.watch(AccountCreationProvider);

    }catch (e){
      print("Failed to get a profile from the backend.");
      print(e);
      //return empty objects.
    }
    Tuple2<Profile, ProfileImages> returnvalue = Tuple2(profile,profileImages);
    return returnvalue;
  }

  //they it should update the database, and then navigate back to /home/profile.
  Future<void> submit() async {

  }

  cancel() {
    context.go('/home/profile');
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
      child: FutureBuilder<Tuple2<Profile,ProfileImages>>(
        future: _initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return Text("waiting");
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else {
                return DefaultTabController(
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
                                  onPressed: () => {
                                    cancel()
                                  },
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
                );
              }
          }
        }
      ),
    );
  }
}
