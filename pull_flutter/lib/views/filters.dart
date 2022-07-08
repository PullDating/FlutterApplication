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
          child: ListView(
            children: [
              FilterListItem(
                  icon: Icon(Icons.access_time_outlined),
                  title: "ehllo ther",
                  widget: Text("hello")),
              const ListTile(
                leading: Icon(Icons
                    .transgender), //this probably needs to change, but idk the icon for just gender
                title: Text('Gender'),
              ),
              const ListTile(
                leading: Icon(Icons.access_time_outlined),
                title: Text('Age'),
              ),
              const ListTile(
                leading: Icon(Icons.social_distance),
                title: Text('Distance'),
              ),
              const ListTile(
                leading: Icon(Icons.height),
                title: Text('Height'),
              ),
              const ListTile(
                leading: Icon(Icons.man_outlined),
                title: Text('Body Type'),
              ),
              const ListTile(
                //leading: Icon(Icons.man_outlined),
                title: Text(
                    "You will only see people who match these filters, and you will only be shown to people who's filters you match."),
              ),
              const ListTile(
                //leading: Icon(Icons.man_outlined),
                title: Text('Dating goal will match your selection.'),
              ),
            ],
          ),
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
