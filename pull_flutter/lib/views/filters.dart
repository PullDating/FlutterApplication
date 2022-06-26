import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double? distance; //distance from user in km


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    distance = 10;

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Text("hello"),
          /*
          child: ListView(
            children: [
              /*
              FilterListItem(
                icon: Icon(Icons.social_distance),
                title: "A title",
                widget: Slider(
                  min: 0.1,
                  max: 50,
                  divisions: 100,
                  value: distance!,
                  onChanged: (value) {
                    setState(() {
                      distance = value;
                      print("distance updated: $distance");
                    });
                  },
                ),
              ),
              */
              ListTile(
                leading: Icon(Icons.social_distance),
                title: Text('Distance'),
                subtitle: Text("Subtitle"),
                trailing: Container(
                    child: Row(
                      children: [
                        Text("Some more text"),
                      ],
                    )
                ),
                /*
                Slider(
                  min: 0.1,
                  max: 50,
                  divisions: 100,
                  value: distance!,
                  onChanged: (value) {
                    setState(() {
                      distance = value;
                    });
                  },
                ),
                 */
              ),
              ListTile(
                leading: Icon(Icons.transgender), //this probably needs to change, but idk the icon for just gender
                title: Text('Gender'),
              ),
              ListTile(
                leading: Icon(Icons.access_time_outlined),
                title: Text('Age'),
              ),
              ListTile(
                leading: Icon(Icons.social_distance),
                title: Text('Distance'),
              ),
              ListTile(
                leading: Icon(Icons.height),
                title: Text('Height'),
              ),
              ListTile(
                leading: Icon(Icons.man_outlined),
                title: Text('Body Type'),
              ),
              ListTile(
                //leading: Icon(Icons.man_outlined),
                title: Text("You will only see people who match these filters, and you will only be shown to people who's filters you match."),
              ),
              ListTile(
                //leading: Icon(Icons.man_outlined),
                title: Text('Dating goal will match your selection.'),
              ),
            ],
          ),

           */
        ),
      ),
    );
  }
}

class FilterListItem extends StatelessWidget {
  final Icon icon;
  final Widget widget;
  String? title;
  FilterListItem({
    Key? key,
    required this.icon,
    required this.widget,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          icon,
          Container(
            width: 10,
          ),
          (title != null) ? Text(title!) : Text(''),
          widget,
        ],
      ),
    );
  }
}

