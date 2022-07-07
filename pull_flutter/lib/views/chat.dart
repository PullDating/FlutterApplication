import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:pull_flutter/ui/activity_indicator.dart';

String randomString(){
  final random = Random.secure();
  final values = List<int>.generate(16,(i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}



class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = []; //list of messages
  var _user;
  var _otheruser;
  late Image matchPicture;
  //TODO update these so that they take in the name and age of the actual match.
  late String name;
  late int age;

  Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  void _addMessages(types.Message message){
    setState(() {
      _messages.insert(0,message);
    });
  }


  @override
  initState() {
    // TODO: implement initState
    super.initState();
    
    //TODO get the correct matchPicture to display instead of network image.
    matchPicture = Image.network('https://i.insider.com/59b6c4bfba785e36f932a317?width=1000&format=jpeg&auto=webp');
    name = "Mary";
    age = 32;


    //TODO get the uuid of the logged in user and replace the id here.
    _user = types.User(id: "-1"); //the use of the application

    _otheruser = types.User(id: widget.uuid); //their match.

    //some debug / test print stuff.
    final _message = types.PartialText(
      text: "hello there, general kenobi",
    );
    final textMessage = types.TextMessage(
      author: _otheruser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: _message.text,
    );
    _addMessages(textMessage);
  }

  void _handleSendPressed(types.PartialText message){
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessages(textMessage);
  }



  @override
  Widget build(BuildContext context) {

    final headPercent = 0.1;
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: availableHeight*headPercent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.arrow_back_ios_new_rounded),
                    Spacer(flex: 4,),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: (availableHeight*headPercent)/2,
                          backgroundImage: matchPicture.image,
                          backgroundColor: Colors.transparent,
                        ),
                        new Positioned(
                          child: new ActivityIndicator(state: 'inactive',),
                          top: 47.0,
                          left: 47.0,
                        ),
                      ],
                    ),
                    Spacer(),
                    Text("${name}, ${age}"),
                    Spacer(flex: 20,),
                  ],
                ),
              ),
              Container(
                height: availableHeight*(1-headPercent),
                child: Chat(
                  theme: const DefaultChatTheme(
                    inputBackgroundColor: Colors.black,
                    primaryColor: Colors.lightBlueAccent,
                    secondaryColor: Colors.pinkAccent,
                  ),
                  messages: _messages,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                ),
              ),
            ],
          ),
        ),
      ),
    );



  }
}

