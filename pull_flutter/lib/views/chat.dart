import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

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

  void _addMessages(types.Message message){
    setState(() {
      _messages.insert(0,message);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Chat(
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
      ),
    );



  }
}
