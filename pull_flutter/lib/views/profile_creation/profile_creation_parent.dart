import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_flutter/views/profile_creation/biography_field.dart';
import 'package:pull_flutter/views/profile_creation/birthdate_field.dart';
import 'package:pull_flutter/views/profile_creation/bodytype_field.dart';
import 'package:pull_flutter/views/profile_creation/dating_goal_field.dart';
import 'package:pull_flutter/views/profile_creation/gender_field.dart';
import 'package:pull_flutter/views/profile_creation/height_field.dart';
import 'package:pull_flutter/views/profile_creation/photo_field.dart';
import 'package:pull_flutter/views/profile_creation/name_field.dart';
import 'package:pull_common/pull_common.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import '../../model/profile_creation_base.dart';
import '../../model/routes.dart';

class ProfileCreationParent extends ConsumerStatefulWidget {
  const ProfileCreationParent(
      {Key? key, required this.title, required this.path})
      : super(key: key);

  final String title;
  final String path;

  @override
  ConsumerState<ProfileCreationParent> createState() =>
      _ProfileCreationParentState();
}

class _ProfileCreationParentState extends ConsumerState<ProfileCreationParent>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //List<ValueNotifier<bool>> _bottomButtonActive = [];

  //Location variables.
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  //navigation behaviour
  void goToNext() {
    print('go to next was called');
    setState(() {
      var i = tabs.keys.toList().indexOf(widget.path);
      context.go('/createProfile/${tabs.keys.elementAt(i + 1)}');
    });
  }

  void finalClick() async {
    //get the longitude and latitude of the device.
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print("location Data: $_locationData");

    ref.read(AccountCreationProvider.notifier).setLongitude(_locationData.longitude!);
    ref.read(AccountCreationProvider.notifier).setLatitude(_locationData.latitude!);

    print("\n\n\n\n\n\n\n\n");
    //print("I'm going to try uploading the stuff now");

    //Photo Compression
    List<File?> images = ref.read(ProfilePhotosProvider.notifier).getImages();
    try {
      images = await compressProfilePhotos(images);
      print("images: " + images.toString());
      ref.read(ProfilePhotosProvider.notifier).setImages(images);
    } catch (e){
      print("error: " + e.toString());
    }

    // try{
    //   PullRepository repo = PullRepository(ref.read);
    //   await repo.createProfile();
    // }catch (e){
    //   print("There was an error somewhere in the profile creation.");
    //   print(e);
    //   return;
    // }

    setState(() async {

      //go to the filter creation process.
      context.go('/filters', extra: FilterPageInput(filterPageDone, false, null));

    });
  }

  void filterPageDone(BuildContext context, WidgetRef ref, Filters filters) async {

    print("Filter page done");

    //TODO create a profile
    try{
      PullRepository repo = PullRepository(ref.read);
      await repo.createFilterRequest(filters);
      await repo.createProfile();
      context.go('/home/cards');
    }catch (e){
      print("There was an error somewhere in the profile creation.");
      print(e);
      return;
    }
    //TODO set the filters for that profile.
    //TODO call the createFilterRequest.

  }

  void getPhotoLimits() async {
    print("got into getPhotoLimits");
    var url = profilePhotoLimitsUri;
    var decoded;


    try {
      var response = await http.get(url).timeout(const Duration(seconds: 3));
      if(response.statusCode == 200){
        print("Success");
        decoded = json.decode(response.body);
        print("attemping to set state with new photo limits");
        ref.read(ProfilePhotosProvider.notifier).setMax(decoded['maxProfilePhotos']);
        ref.read(ProfilePhotosProvider.notifier).setMin(decoded['minProfilePhotos']);
        ref.read(ProfilePhotosProvider.notifier).setImages(List<File?>.filled(ref.read(ProfilePhotosProvider.notifier).getMax(), null));
      }else{
        print("Something wrong");
      }
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


  late Map<String, Widget> tabs;
  late List<File?> images;

  @override
  void initState() {
    super.initState();
    print("about to set the images watch");

    getPhotoLimits();
    tabs = <String, Widget>{
      'name': ProfileCreationTemplate(
          entryField: const ProfileNameField(),
          title: "Add Your Name",
          onNext: goToNext),
      'add_photos': ProfileCreationTemplate(
        entryField: const ProfilePhotoField(),
        title: "Add Your Photos",
        onNext: goToNext,
      ),
      'birthdate': ProfileCreationTemplate(
        entryField: const ProfileBirthDateField(),
        title: "Enter your Birth Date",
        onNext: goToNext,
      ),
      'gender': ProfileCreationTemplate(
        entryField: const ProfileGenderField(),
        title: "What's your gender?",
        onNext: goToNext,
      ),
      'height': ProfileCreationTemplate(
        entryField: const ProfileHeightField(),
        title: "How tall are you?",
        onNext: goToNext,
      ),
      'bodytype': ProfileCreationTemplate(
        entryField: const ProfileBodyTypeField(),
        title: "What's your body type?",
        onNext: goToNext,
      ),
      'datinggoal': ProfileCreationTemplate(
        entryField: const ProfileDatingGoalField(),
        title: "What are you looking for?",
        onNext: goToNext,
      ),
      'biography': ProfileCreationTemplate(
        entryField: const ProfileBiographyField(),
        title: "Write a bit about yourself.",
        onNext: finalClick,
        isLast: true,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(AccountCreationProvider);
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: widget.title.substring(0, widget.title.length ~/ 2),
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                    fontSize: 24),
              ),
              TextSpan(
                text: widget.title
                    .substring(widget.title.length ~/ 2, widget.title.length),
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                    fontSize: 24),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.fastOutSlowIn,
        child: tabs[widget.path],
        transitionBuilder: (_widget, animation) {
          /// If this is the incoming widget, we need to animate it in. Otherwise we need to animate it out.
          if (_widget == tabs[widget.path]!) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 0.06), end: Offset.zero)
                    .animate(animation),
                child: _widget,
              ),
            );
          } else {
            return FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(animation),
              child: _widget,
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: tabs.keys.toList().indexOf(widget.path),
        items: const [
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.circle_rounded,
                size: 15,
              )),
        ],
        onTap: (i) {
          context.go('/createProfile/${tabs.keys.elementAt(i)}');
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
