import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_flutter/views/profileCreation/biographyfield.dart';
import 'package:pull_flutter/views/profileCreation/birthdatefield.dart';
import 'package:pull_flutter/views/profileCreation/bodytypefield.dart';
import 'package:pull_flutter/views/profileCreation/datinggoalfield.dart';
import 'package:pull_flutter/views/profileCreation/genderfield.dart';
import 'package:pull_flutter/views/profileCreation/heightfield.dart';
import 'package:pull_flutter/views/profileCreation/photofield.dart';
import 'package:pull_flutter/views/profileCreation/namefield.dart';
import 'package:pull_flutter/views/tabs/card_swipe_tab.dart';
import 'package:pull_flutter/views/tabs/chats_tab.dart';
import 'package:pull_flutter/views/tabs/profile_tab.dart';

import 'package:pull_common/src/model/provider/create_account.dart';

import '../../model/profile_creation_base.dart';



class ProfileCreationParent extends ConsumerStatefulWidget {
  const ProfileCreationParent({Key? key, required this.title, required this.path}) : super(key: key);

  final String title;
  final String path;

  @override
  ConsumerState <ProfileCreationParent> createState() => _ProfileCreationParentState();
}

class _ProfileCreationParentState extends ConsumerState<ProfileCreationParent> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  //List<ValueNotifier<bool>> _bottomButtonActive = [];

  void goToNext(){
    print('go to next was called');
    setState(() {
      var i = tabs!.keys.toList().indexOf(widget.path);
      context.go('/createProfile/${tabs!.keys.elementAt(i+1)}');
    });
  }


  void finalClick() {
    //print("You clicked the final next button for the sign up process");
    setState(() {
      //this is where we actually need to convert the states that we've collected into a database query
      var jsonResult = ref.read(accountCreationProvider).toJson();
      print(jsonResult);
      //TODO send api request with this data to /createProfile

      context.go('/home/cards');
    });
  }

  late Map<String,Widget> tabs;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_bottomButtonActive = <ValueNotifier<bool>>[
    //  ValueNotifier(true),
    //  ValueNotifier(false),
    //  ValueNotifier(false)
    //];



    tabs = <String,Widget>{
      'name' : ProfileCreationTemplate(entryField: ProfileNameField(),title: "Add Your Name",nextfunction: goToNext),
      'add_photos' : ProfileCreationTemplate(entryField: ProfilePhotoField(),title: "Add Your Photos",nextfunction: goToNext,),
      'birthdate' : ProfileCreationTemplate(entryField: ProfileBirthDateField(),title: "Enter your Birth Date",nextfunction: goToNext,),
      'gender' : ProfileCreationTemplate(entryField: ProfileGenderField(),title: "What's your gender?",nextfunction: goToNext,),
      'height' : ProfileCreationTemplate(entryField: ProfileHeightField(),title: "How tall are you?",nextfunction: goToNext,),
      'bodytype' : ProfileCreationTemplate(entryField: ProfileBodyTypeField(),title: "What's your body type?",nextfunction: goToNext,),
      'datinggoal' : ProfileCreationTemplate(entryField: ProfileDatingGoalField(),title: "What are you looking for?",nextfunction: goToNext,),
      'biography' : ProfileCreationTemplate(entryField: ProfileBiographyField(),title: "Write a bit about yourself.",nextfunction: finalClick,isLast: true,),
    };
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountCreationProvider);
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
                text: widget.title.substring(0,widget.title.length ~/ 2),
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 24
                ),
              ),
              TextSpan(
                text: widget.title.substring(widget.title.length ~/ 2, widget.title.length),
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                    fontSize: 24
                ),
              ),
            ],
          ),
          
          //widget.title,

        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.fastOutSlowIn,
        child: tabs![widget.path],
        transitionBuilder: (_widget, animation){
          /// If this is the incoming widget, we need to animate it in. Otherwise we need to animate it out.
          if (_widget == tabs![widget.path]!) {
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
        currentIndex: tabs!.keys.toList().indexOf(widget.path),
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          ),
        ],
        onTap: (i) {
          context.go('/createProfile/${tabs!.keys.elementAt(i)}');
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
