import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pull_common/pull_common.dart';

/*
This class mocks the login functionality so that developers can edit the rest
of the application without having to go through the sms process each time.
*/
class DevLogin extends StatefulWidget {
  const DevLogin({Key? key}) : super(key: key);

  @override
  State<DevLogin> createState() => _DevLoginState();
}

class _DevLoginState extends State<DevLogin> {
  final String uuid = 'b6a9f755-7668-483d-adc8-16b3127b81b8'; //the uuid to store in hive.
  final String token = '6b7d6e66-734b-495b-b76e-b0dfea8e81ef'; //the token to store in hive.
  final bool newProfile = false; //indicates if they need to go to profile creation or main page.

  void _setAndNavigate () async {
    var Box = await Hive.openBox(kSettingsBox);
    Box.put(kSettingsApiToken,token);
    Box.put(kSettingsUUID,uuid);
    if(newProfile){
      context.go('/createProfile/name');
    } else{
      context.go('/home/cards');
    }
  }

  @override
  void initState(){
    _setAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Text("This is for dev login only, report if you see this in production."),
      ),
    );
  }
}
