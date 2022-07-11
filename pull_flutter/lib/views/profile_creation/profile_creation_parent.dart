import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

import '../../model/profile_creation_base.dart';

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

  void goToNext() {
    print('go to next was called');
    setState(() {
      var i = tabs.keys.toList().indexOf(widget.path);
      context.go('/createProfile/${tabs.keys.elementAt(i + 1)}');
    });
  }

  void finalClick() async {
    //print("You clicked the final next button for the sign up process");
    setState(() async {
      //TODO get the location
      //for now I'm going to fake it.
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

      //this is where we actually need to convert the states that we've collected into a database query
      //TODO this function isn't creating valid json, it doesn't have the string quotations because it is just a Map.
      var jsonResult = ref.read(AccountCreationProvider).toJson();
      print(jsonResult);
      //TODO send api request with this data to /createProfile
      context.go('/home/cards');
    });
  }

  late Map<String, Widget> tabs;

  @override
  void initState() {
    super.initState();

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
