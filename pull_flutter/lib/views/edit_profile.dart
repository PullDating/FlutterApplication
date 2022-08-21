import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late ProfileImages profileImages = ProfileImages(
      images: [],
      mandatoryFilled: false,
      max: 6,
      min: 3,
      numFilled: 0);

  //display variables:
  bool edit = true; //true for edit mode, false for preview mode.

  @override
  void initState() {
    _initialize();
    //TODO get the profile information from the backend.
    super.initState();
  }

  //get the information from the database, and write it to profile.
  Future<void> _initialize() async {
    try {
      PullRepository repo = PullRepository(ref.read);
      await repo.getProfile(ref);
      print("get profile done, attempting to set the profile and ProfileImages");
      //get the information from the profile providers
      // now update the local copies of everything accordingly
      profileImages = await ref.read(ProfilePhotosProvider);
      profile = await ref.read(AccountCreationProvider);
      print("profile and profileimages loaded");
      print(profile);
      print(profileImages);
      //load in to the relevant text controllers
      biographyController.text = (profile.biography == null)? '' : profile.biography!;
    } catch (e) {
      print("Failed to get a profile from the backend.");
      print(e);
      //return empty objects.
    }
  }

  //they it should update the database, and then navigate back to /home/profile.
  Future<void> submit() async {
    print("submit pressed");
  }

  cancel() {
    context.go('/home/profile');
  }

  _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      // //check to make sure they aren't arranging the empty ones
      // if(imageList[oldIndex] == null){
      //   print("cannot move an empty image tile.");
      //   return;
      // }
      //
      // File? temp = imageList[oldIndex];
      // imageList[oldIndex] = imageList[newIndex];
      // imageList[newIndex] = temp;
      // //TODO save the new order in riverpods
      //
    });
  }

  _pickPhoto() {
    print("_pickPhoto pressed");
  }

  _deletePhoto() {
    print("_deletePhoto pressed");
  }

  //Things they should be able to change
  /*
  photos
  gender
  datingGoal
  biography
  bodyType
   */

  //I want it to have two sides: One that is the edit, and the other that is preview
  //the person should be able to swap back and forth between them at will
  //they should be able to save from either.

  TextEditingController biographyController = TextEditingController();
  //TODO get this from the backend/providers.
  int biographyMaxCharacters = 300;

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kTextTabBarHeight;

    try {

      print("profileImages.min: ${profileImages.min}");
      print("profileImages.max: ${profileImages.max}");
      print("profileImages.images.length: ${profileImages.images.length}");

      var tiles = <ImageThumbnailV2>[];

      for (int i = 0; i < profileImages.min; i++) {
        if (profileImages.images.length > i) {
          tiles.add(ImageThumbnailV2(
            image: profileImages.images[i],
            pickImage: _pickPhoto,
            deleteImageCallback: _deletePhoto,
            index: i,
            required: true,
            mandatoryFilled: profileImages.mandatoryFilled,
          ));
        } else {
          tiles.add(ImageThumbnailV2(
            image: null,
            pickImage: _pickPhoto,
            deleteImageCallback: _deletePhoto,
            index: i,
            required: true,
            mandatoryFilled: profileImages.mandatoryFilled,
          ));
        }
      }
      //for the not mandatory to be filled.
      for (int i = profileImages.min; i < min(
          max(profileImages.min + 1, profileImages.numFilled + 1),
          profileImages.max); i++) {
        print("i: $i");

        if (profileImages.images.length > i) {
          tiles.add(ImageThumbnailV2(
            image: profileImages.images[i],
            pickImage: _pickPhoto,
            deleteImageCallback: _deletePhoto,
            index: i,
            required: false,
            mandatoryFilled: profileImages.mandatoryFilled,
          ));
        } else {
          tiles.add(ImageThumbnailV2(
            image: null,
            pickImage: _pickPhoto,
            deleteImageCallback: _deletePhoto,
            index: i,
            required: false,
            mandatoryFilled: profileImages.mandatoryFilled,
          ));
        }
      }
    } catch (e) {
      print(e);
      throw Exception("There was a problem trying to fill the profile fields");
    }

    return Material(
      //TODO modify the Profile Photo tab to get the information from the ProfileImages instead of the provider,since it should not update the provider unless they are successful.
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "Edit",
                    ),
                    Tab(
                      text: "Preview",
                    ),
                  ],
                ),
                //this contains the update two tabs and all the logic
                Container(
                  height: availableHeight * 0.9,
                  child: TabBarView(
                    children: [
                      //edit
                      Container(
                        child: Column(
                          children: [
                            PhotoField(
                              onReorder: _reorderPhotos,
                              tiles: [],
                            ),
                            BiographyBox(
                              maxCharacters: biographyMaxCharacters,
                              controller: biographyController,
                            ),
                            
                          ],
                        ),
                      ),
                      //preview
                      Container(
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                //this serves as a bottom app bar for saving or cancelling.
                Container(
                  color: Colors.lightBlueAccent,
                  height: availableHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => {cancel()},
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

class PhotoField extends StatelessWidget {
  PhotoField({
    Key? key,
    required this.onReorder,
    required this.tiles,
  }) : super(key: key);

  Function(int, int) onReorder;
  List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapList(
                  onReorder: onReorder,
                  tiles: tiles,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BiographyBox extends StatelessWidget {
  BiographyBox({
    Key? key,
    required this.maxCharacters,
    required this.controller,
  }) : super(key: key);

  int maxCharacters;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Container(
        child: Column(
          children: [
            TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxCharacters),
              ],
              minLines: 1,
              maxLines: 5,
              obscureText: false,
              controller: controller,
              onChanged: (String value) {
                controller.text = value;
                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

                print(
                    "Current number of characters: ${controller.text.characters.length}");
              },
            ),
            Text(
              (controller.text.characters.length >= 300)
                  ? "Max Characters Reached!"
                  : "${controller.text.characters.length}/$maxCharacters",
              style: TextStyle(
                color: (controller.text.characters.length >= 300)
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
