import 'package:flutter/material.dart';




class ActivityIndicator extends StatefulWidget {

  const ActivityIndicator(
      {Key? key, required this.state}) : super(key: key);

  final String state;

  @override
  State<ActivityIndicator> createState() => _ActivityIndicatorState();
}

class _ActivityIndicatorState extends State<ActivityIndicator> {
  Color? color;
  String? message;
  @override
  void initState() {
    if(widget.state == 'active'){
      color = Colors.green;
      message = "This person is currently active on the app.";
    }else if (widget.state == 'recently active') {
      color = Colors.orange;
      message = "This person was recently active, but is not currently online.";
    }else if (widget.state == 'inactive'){
      color = Colors.red;
      //TODO make this more specific with data from database.
      message = "This person has been inactive for a while.";
    }else if (widget.state == 'dormant'){
      color = Colors.black38;
      message = "This person's profile is dormant, meaning they haven't been active in a very long time.";
    }else{
      print("There was an error with the state passed in to the ActivityIndicator.");
      message = "There is an error in the code. Please report this to staff.";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = 25.0;

    return InkResponse(
      onTap: () {
        //TODO show dialog with information on what it means.
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Recent User Activity"),
            content: Text(message!),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
      },
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
            //height: size - 5,
            //width: size - 5,
            child: FittedBox(child: Icon(Icons.access_time))
        )
      ),
    );
  }
}