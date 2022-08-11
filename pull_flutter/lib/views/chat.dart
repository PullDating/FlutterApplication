import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
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


  Object _formMessage(String meta, String? message, String targetID, String clientID, String token){

    var obj = {
      "meta" : meta,
      "targetID" : targetID,
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
    Object request = _formMessage("send_message", text, "22222222-2222-2222-2222-222222222222", "b6a9f755-7668-483d-adc8-16b3127b81b8", '6b7d6e66-734b-495b-b76e-b0dfea8e81ef');
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
    Object request = _formMessage("join_or_create_room", null, "22222222-2222-2222-2222-222222222222", "b6a9f755-7668-483d-adc8-16b3127b81b8", '6b7d6e66-734b-495b-b76e-b0dfea8e81ef');
    //print(request.toString());
    channel.sink.add(jsonEncode(request));



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

    channel.stream.listen((data) {
      print("!!!new message: ${data}");
      var response = jsonDecode(data);
      if(response['status'] == 1){
        //TODO add this as a message from the other person in the ui.
        setState(() {
          final _message = types.PartialText(
            text: response['message'],
          );
          final textMessage = types.TextMessage(
            author: _otheruser,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: randomString(),
            text: _message.text,
          );
          _addMessages(textMessage);
        });
      } else {
        print("there was an error with a message received: ${response['message']}");
        //return to the match screen
        Fluttertoast.showToast(
            msg: "No match exists between you and this person, please report this error to the dev team.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        context.go('/home/chats');
        //display flutter toast.
        channel.sink.close();
      }
    });
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
