import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  /// Stores the reordering information for the profile update call.
  /// The key is the new position in the update photo list.
  /// The value is the old position from the photo list
  /// If the old value is -1 that means that it is a newly updated photo.
  late List<int> reorderPhotos;

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

  ///the uuid of the user in question, not really needed for this one.
  late String uuid;

  //get the information from the database, and write it to profile.
  Future<void> _initialize() async {

    String? uuidtemp = ref.watch(UUIDProvider);
    if(uuidtemp != null){
      uuid = uuidtemp!;
    } else {
      uuid = 'testtesttest';
    }

    //TODO save the initial reorder, add, and delete maps for later api use.

    //TODO fix this function, it is not getting the accurate values from the database, just the old values.

    try {
      PullRepository repo = PullRepository(ref.read);
      Tuple2<Profile,ProfileImages> profileGet = await repo.getProfile(ref,null);
      print("get profile done, attempting to set the profile and ProfileImages");
      setState((){
        print("calling set state on edit page.");
        profileImages = profileGet.item2;
        print(profileImages);
        profile = profileGet.item1;
        biographyController.text = (profile.biography == null)? '' : profile.biography!;
        //for the other settings, need to set the correct starting values.

        //dating goal
        for(int i = 0; i < datingGoalValues.length; i++){
          if(datingGoalValues[i] == profile.datinggoal){
            datingGoalChecked[i] = true;
          } else {
            datingGoalChecked[i] = false;
          }
        }

        //gender
        for(int i = 0; i < genderValues.length; i++){
          if(genderValues[i] == profile.gender){
            genderChecked[i] = true;
          } else {
            genderChecked[i] = false;
          }
        }

        //body type
        for(int i = 0; i < bodyTypeValues.length; i++){
          if(bodyTypeValues[i] == profile.bodytype){
            bodyTypeChecked[i] = true;
          } else {
            bodyTypeChecked[i] = false;
          }
        }

      });

      //Set the reorder photos to what is already in the database.
      reorderPhotos = [];
      for(int i = 0; i < profileImages.images.length; i++){
        reorderPhotos.add(i);
      }
      print("reorderPhotos:");
      print(reorderPhotos);

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
    print("reorder photos:" + reorderPhotos.toString());
    print("profile images: " + profileImages.toString());
    profile = profile.copyWith(biography: biographyController.text);

    //send a request to the database to update the profile based on the profile that is here
    try {
      PullRepository repo = PullRepository(ref.read);
      await repo.updateProfile(ref, profile, profileImages, reorderPhotos).then((value) => {
        context.go('/home/profile')
      });
    } on TimeoutException catch (e) {
      print('Timeout');
      Fluttertoast.showToast(
          msg: "You're having connectivity issues, please check connection and reset your app.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  cancel() {
    context.go('/home/profile');
  }

  //need to keep track of these for the api request

  //TODO keep track of the reorders to send to api call.
  _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      //check to make sure they aren't arranging the empty ones

      //if length is 6, then an invalid old index would be 6 so greater than or equal to
      if(profileImages.images[oldIndex] == null || oldIndex >= profileImages.images.length){
        print("cannot move an empty image tile.");
        return;
      }
      ProfileImages tempImages = profileImages;
      File? temp = tempImages.images[oldIndex];
      //remove at the old index
      tempImages.images.removeAt(oldIndex);

      //remove from reorderPhotos
      int reorderTemp = reorderPhotos.removeAt(oldIndex);

      //insert at the new index
      tempImages.images.insert(newIndex, temp);

      //add to reorderPhotos
      reorderPhotos.insert(newIndex, reorderTemp);
      print("reordePhotos");
      print(reorderPhotos);

      profileImages = tempImages;

      //handle the update to reorder photos
      //It should get the new old location from the previous old location

    });
  }

  //TODO keep track of the added photos for the api.
  _pickPhoto(int index) async {
    try {
      print("trying to pick image.");
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      //check to make sure it didn't pick an empty file, or fail.
      if (image == null){
        print("image was null, didn't pick image.");
        return;
      }

      //store a temporary list while the rearranging is done, as well as some temp variables.
      List<File?> tempimages = profileImages.images;
      int tempnumfilled = profileImages.numFilled;
      bool tempmandatory = profileImages.mandatoryFilled;

      //check to make sure that is is within the valid range of indexes.
      if(index < profileImages.max && index >= 0){
        if(tempimages.length <= index){
          //need to append an empty value first
          tempimages.add(File(image.path));
        } else {
          //otherwise, just set the right place to the new value.
          tempimages[index] = File(image.path);
        }

        //handle the add to reorderPhotos
        reorderPhotos.insert(index, -1);

        print("reorderPhotos");
        print(reorderPhotos);

        //todo I don't think that this line is necessary, as we already handled it.
        //tempimages[index] = File(image.path);

        //adjust tempnumfilled and the tempmandatory variables.
        tempnumfilled++;
        if(tempnumfilled >= profileImages.min){
          tempmandatory = true;
        }

        //set state with the new values for the photos.
        setState(() {
          profileImages = profileImages.copyWith(
              images: tempimages,
              numFilled: tempnumfilled,
              mandatoryFilled: tempmandatory
          );
        });
      } else {
        throw "The index you tried to replace is out of range";
      }

      //profileImages.images[index] = File(image.path);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  //TODO keep track of the deleted photos for the api.
  _deletePhoto(int index) {
    print("_deletePhoto pressed");
    setState((){

      List<File?> tempimages = profileImages.images;
      int tempnumfilled = profileImages.numFilled;
      bool tempmandatory = profileImages.mandatoryFilled;

      tempimages.removeAt(index);
      tempnumfilled = tempnumfilled - 1;

      if(tempnumfilled < profileImages.min){
        tempmandatory = false;
      }

      reorderPhotos.removeAt(index);

      //copy with the new image list.
      profileImages = profileImages.copyWith(
          images: tempimages,
          numFilled: tempnumfilled,
          mandatoryFilled: tempmandatory
      );

      print("reorderPhotos");
      print(reorderPhotos);
    });

  }

  _datingGoalPressed(int index){
    print("dating goal pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < datingGoalChecked.length; i++){
        datingGoalChecked[i] = false;
      }
      datingGoalChecked[index] = true;
      profile = profile.copyWith(datinggoal: datingGoalValues[index]);
    });
  }
  _bodyTypePressed(int index){
    print("bodyType pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < bodyTypeChecked.length; i++){
        bodyTypeChecked[i] = false;
      }
      bodyTypeChecked[index] = true;
      profile = profile.copyWith(datinggoal: bodyTypeValues[index]);
    });
  }
  _genderPressed(int index){
    print("gender pressed with index: ${index}");
    setState(() {
      for(int i = 0; i < genderChecked.length; i++){
        genderChecked[i] = false;
      }
      genderChecked[index] = true;
      profile = profile.copyWith(datinggoal: genderValues[index]);
    });
  }

  List<Media> _getMediaFromProfileImages(ProfileImages profileImages){
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
    //print("values: ${values}");
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
        //print("i: $i");

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
                                  distanceInMeters: 0,
                                  uuid: uuid,
                                  //TODO get the age from the birthDate
                                  //int upperAge = ((DateTime.now().difference(minBirthDate).inDays)/365.26).truncate();
                                  //int lowerAge = ((DateTime.now().difference(maxBirthDate).inDays)/365.26).truncate();
                                  age: ((DateTime.now().difference(profile.birthdate!).inDays)/365.26).truncate(),
                                  displayName: profile.name!,
                                  bio: profile.biography!,
                                  bodyType: profile.bodytype,
                                  pronouns: "He/Him",
                                  media: getMediaFromProfileImages(profileImages),
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
                        onPressed: () => {submit()},
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
