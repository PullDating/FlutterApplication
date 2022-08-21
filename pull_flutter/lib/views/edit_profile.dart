import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/views/filters.dart';
import 'package:pull_flutter/views/profile_creation/photo_field.dart';
import 'package:tuple/tuple.dart';
import 'package:pull_common/src/model/entity/media.dart';

import '../ui/match_card.dart';

//TODO modify this in order to get the stored profile instead of database access.
class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late Profile profile = Profile(
    name: "placeholder",
    birthdate: DateTime.now(),
    bodytype: "average",
    gender: "man",
    height: 165,
    biography: ""

  );
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
    super.initState();
  }

  List<bool> datingGoalChecked = [true, false, false, false, false, false];
  List<String> datingGoalOptionNames = ['Long-term Relationship', 'Short-term Relationship', 'Hookup/Casual', 'Marriage', 'Just Chatting', 'Unsure'];
  List<String> datingGoalValues = ['longterm', 'shortterm', 'hookup', 'marriage', 'justchatting', 'unsure'];
  List<bool> bodyTypeChecked = [true,false,false,false,false];
  List<String> bodyTypeOptionNames = ['Lean', 'Average', 'Muscular', 'Heavy', 'Obese'];
  List<String> bodyTypeValues = ['lean', 'average', 'muscular', 'heavy', 'obese'];
  List<bool> genderChecked = [true, false, false];
  List<String> genderOptionNames = ["Man","Woman","Non-Binary"];
  List<String> genderValues = ["man","woman","non-binary"];

  //get the information from the database, and write it to profile.
  Future<void> _initialize() async {
    try {
      PullRepository repo = PullRepository(ref.read);
      await repo.getProfile(ref);
      print("get profile done, attempting to set the profile and ProfileImages");
      profileImages = await ref.read(ProfilePhotosProvider);
      profile = await ref.read(AccountCreationProvider);
      setState(()  {
        biographyController.text = (profile.biography == null)? '' : profile.biography!;
      });
    } catch (e) {
      print("Failed to get a profile from the backend.");
      print(e);
      //return empty objects.
    }
  }

  //todo implement submit
  //they it should update the database, and then navigate back to /home/profile.
  Future<void> submit() async {
    print("submit pressed");
    //send a request to the database to update the
  }

  cancel() {
    context.go('/home/profile');
  }

  //TODO implement reorder photos
  _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      //check to make sure they aren't arranging the empty ones
      if(profileImages.images[oldIndex] == null){
        print("cannot move an empty image tile.");
        return;
      }

      File? temp = profileImages.images[oldIndex];
      profileImages.images[oldIndex] = profileImages.images[newIndex];
      profileImages.images[newIndex] = temp;
      //TODO save the new order in riverpods

    });
  }

  //TODO implement pick photo
  _pickPhoto() {
    print("_pickPhoto pressed");
  }
  //TODO implement delete photo
  _deletePhoto() {
    print("_deletePhoto pressed");
  }



  _datingGoalPressed(int index){
    print("dating goal pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < datingGoalChecked.length; i++){
        datingGoalChecked[i] = false;
      }
      datingGoalChecked[index] = true;
    });
  }
  _bodyTypePressed(int index){
    print("bodyType pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < bodyTypeChecked.length; i++){
        bodyTypeChecked[i] = false;
      }
      bodyTypeChecked[index] = true;
    });
  }
  _genderPressed(int index){
    print("gender pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < genderChecked.length; i++){
        genderChecked[i] = false;
      }
      genderChecked[index] = true;
    });
  }

  List<Media> _getMedia(){
    //for each item in the list of images, find the path and add to a list of uris

    List<Media> values = [];
    try {
      for (int i = 0; i < profileImages.images.length; i++) {
        values.add(Media(
          //pass in the path to the file
          uri: Uri.file(profileImages.images[i]!.path)
        ));
      }
    } catch (e){
      print(e);
      throw Exception("unable to load the profile photo media.");
    }
    print("values: ${values}");
    return values;
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

    var tiles = <ImageThumbnailV2>[];

    try {

      print("profileImages.min: ${profileImages.min}");
      print("profileImages.max: ${profileImages.max}");
      print("profileImages.images.length: ${profileImages.images.length}");



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
                        child: ListView(
                          children: [
                            //edit photos.
                            PhotoField(
                              onReorder: _reorderPhotos,
                              tiles: tiles,
                            ),
                            //edit biography
                            BiographyBox(
                              maxCharacters: biographyMaxCharacters,
                              controller: biographyController,
                            ),
                            //edit dating goals
                            FilterListItem(
                                icon: const Icon(Icons.search),
                                title: "Dating Goal",
                                widget: SingleSelectRow(
                                  onPressed: (int index) {
                                    _datingGoalPressed(index);
                                  },
                                  checked: datingGoalChecked,
                                  optionNames: datingGoalOptionNames,
                                ),
                            ),
                            FilterListItem(
                              icon: const Icon(Icons.man),
                              title: "Body Type",
                              widget: SingleSelectRow(
                                onPressed: (int index) {
                                  _bodyTypePressed(index);
                                },
                                checked: bodyTypeChecked,
                                optionNames: bodyTypeOptionNames,
                              ),
                            ),
                            FilterListItem(
                              icon: const Icon(Icons.transgender),
                              title: "Gender",
                              widget: SingleSelectRow(
                                onPressed: (int index) {
                                  _genderPressed(index);
                                },
                                checked: genderChecked,
                                optionNames: genderOptionNames,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //preview
                      Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PullMatchCard(
                                fromFile: true,
                                match: Match(
                                  //TODO get the age from the birthDate
                                  //int upperAge = ((DateTime.now().difference(minBirthDate).inDays)/365.26).truncate();
                                  //int lowerAge = ((DateTime.now().difference(maxBirthDate).inDays)/365.26).truncate();
                                  age: ((DateTime.now().difference(profile.birthdate!).inDays)/365.26).truncate(),
                                  id: 0,
                                  displayName: profile.name!,
                                  bio: profile.biography!,
                                  bodyType: profile.bodytype,
                                  pronouns: "He/Him",
                                  media: _getMedia(),
                                  gender: profile.gender!,
                                  interests: ["I have no interested","I'm boring"]
                                ),
                              ),
                            ),
                          ],
                        ),
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

class SingleSelectRow extends StatelessWidget {
  SingleSelectRow(
      {
        Key? key,
        required this.checked,
        required this.onPressed(int index),
        required this.optionNames,
      }) : super(key: key);

  //String is the name, bool is whether it is selected or not.

  //these should have the same length
  //TODO convert these to a tuple.
  List<String> optionNames;
  List<bool> checked;

  Function onPressed;

  @override
  Widget build(BuildContext context) {

    //generate the children widgets.
    List<Widget> displayWidgets = [];
    for(int i = 0; i < checked.length; i++){
      displayWidgets.add(
        SizedBox(
          height: 30,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: ElevatedButton(
              onPressed: () {
                onPressed(i);
              },
              child: Text(optionNames[i]),
              style: ElevatedButton.styleFrom(
                primary: (checked[i] == false) ? Colors.grey : Colors.lightBlueAccent,
              ),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: Wrap(
        spacing: 5,
        
        children: displayWidgets,
      ),
    );
  }
}
