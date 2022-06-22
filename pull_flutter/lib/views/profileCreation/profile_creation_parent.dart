import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  final tabs = const <String,Widget>{
    'name' : ProfileCreationTemplate(entryField: ProfileNameField(),title: "Add Your Name",),
    'add_photos' : ProfileCreationTemplate(entryField: ProfilePhotoField(),title: "Add Your Photos",),
  };


  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountCreationProvider);
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.fastOutSlowIn,
        child: tabs[widget.path],
        transitionBuilder: (_widget, animation){
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
            icon: Icon(Icons.circle_rounded)
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.circle_rounded)
          )
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
