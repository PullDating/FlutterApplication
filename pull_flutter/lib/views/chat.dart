import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_common/pull_common.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
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
  late var channel;


  Object _formMessage(String meta, String? message, String roomID, String clientID, String token){
    var obj = {
      "meta" : meta,
      "roomID" : roomID,
      "clientID" : clientID,
      "token" : token,
    };
    if(message != null){
      obj['message'] = message!;
    }else{
      obj['message'] = '';
    }
    return obj;
  }

  void _addMessages(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    //print("about to print message");
    String text = message.toJson()['text'];
    //print(text);
    Object request = _formMessage("send_message", text, "testroom", "311b8f93-a76e-48ba-97cb-c995d0dc918c", 'f46aa34a-76ff-4ae6-b8dd-2e72ff67e86e');
    channel.sink.add(jsonEncode(request));
  }

  @override
  void initState() {
    super.initState();

    //create a web_socket_channel
    channel = WebSocketChannel.connect(
      Uri.parse('ws://${baseAddress}'),
    );

    //Send the request to join the room.
    //TODO replace this with the proper uuid and token.
    Object request = _formMessage("join_or_create_room", null, "testroom", "311b8f93-a76e-48ba-97cb-c995d0dc918c", 'f46aa34a-76ff-4ae6-b8dd-2e72ff67e86e');
    //print(request.toString());
    channel.sink.add(jsonEncode(request));

    channel.stream.listen((data) {
      print("!!!new message: ${data}");
    });

    //TODO get the uuid of the logged in user and replace the id here.
    _user = types.User(id: "-1"); //the use of the application
    _otheruser = types.User(id: widget.uuid); //their match.
    //some debug / test print stuff.

    /*
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

     */
  }

  void _handleSendPressed(types.PartialText message) {
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
          appBar: AppBar(
            title: Text("Some chat"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.grey,
              ),
              onPressed: () {
                context.go('/home/chats');
                channel.sink.close();
              },
            ),
          ),
          body: Chat(
            theme: const DefaultChatTheme(
              inputBackgroundColor: Colors.black,
              primaryColor: Colors.lightBlueAccent,
              secondaryColor: Colors.pinkAccent,),
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
          ),
        ),
      ),
    );
  }
}
