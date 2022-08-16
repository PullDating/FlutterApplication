import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double? distance = 10; //distance from user in km

  @override
  void initState() {
    super.initState();
  }

  bool metricImperial = false;

  bool menChecked = false;
  bool womenChecked = false;
  bool nonBinaryChecked = false;
  double lowerAge = 18;
  double upperAge = 100;
  double lowerHeight = 55;
  double upperHeight = 275;
  double maxDistance = 15;

  bool HeavySet = false;
  bool Stocky = false;
  bool AFewExtraPounds = false;
  bool Average = false;
  bool Athletic = false;
  bool Slender = false;

  @override
  Widget build(BuildContext context) {

    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: availableHeight*0.9,
                child: ListView(
                  children: [
                    SizedBox(height: 20,),
                    FilterListItem(icon: Icon(Icons.transgender),title: "Gender",
                        widget: Row(
                          children: [
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        menChecked = !menChecked;
                                      });
                                    }, child: Text('Men'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (menChecked == false) ? Colors.grey : Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: ElevatedButton(onPressed: () {
                                  setState(() {
                                    womenChecked = !womenChecked;
                                  });

                                }, child: Text('Women'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (womenChecked == false) ? Colors.grey : Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: ElevatedButton(onPressed: () {
                                  setState(() {
                                    setState(() {
                                      nonBinaryChecked = !nonBinaryChecked;
                                    });
                                  });
                                }, child: Text('Non-Binary'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (nonBinaryChecked == false) ? Colors.grey : Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                    child: ElevatedButton(onPressed: () {}, child: Icon(Icons.add))))
                          ],
                        )
                    ),
                    FilterListItem(icon: Icon(Icons.access_time_outlined),title: "Age",
                        widget: SizedBox(
                          width: 280,
                          child: RangeSlider(
                            min: 18,
                            max: 120,
                            divisions: 120-18,
                            values: RangeValues(lowerAge,upperAge),
                            onChanged: (values) {
                              setState(() {
                                lowerAge = values.start;
                                upperAge = values.end;
                              });
                            },
                            labels: RangeLabels(lowerAge.round().toString(),upperAge.round().toString()),
                          ),
                        )
                    ),
                    FilterListItem(icon: Icon(Icons.social_distance),title: "Distance",
                        widget: SizedBox(
                          width: 280,
                          child: Slider(
                            min: 0,
                            max: 100,
                            divisions: 100,
                            value: maxDistance,
                            onChanged: (value) {
                              setState(() {
                                maxDistance = value;
                              });
                            },
                            label: (metricImperial == false) ? "${maxDistance.round().toString()} km" : "${(maxDistance*0.621371).round().toString()} miles",
                          ),
                        )
                    ),
                    FilterListItem(icon: Icon(Icons.height),title: "Height",
                        widget: SizedBox(
                          width: 280,
                          child: RangeSlider(
                            min: 55,
                            max: 275,
                            divisions: 275-55,
                            values: RangeValues(lowerHeight,upperHeight),
                            onChanged: (values) {
                              setState(() {
                                lowerHeight = values.start;
                                upperHeight = values.end;
                              });
                            },
                            labels: RangeLabels((metricImperial == false)? "${lowerHeight.round()} cm" : "${(lowerHeight!~/30.48).round().toString()}\'${(((lowerHeight! / 30.48)-(lowerHeight! ~/ 30.48))*12).toInt().toString()}\""
                                , (metricImperial == false)? "${upperHeight.round()} cm" : "${(upperHeight!~/30.48).round().toString()}\'${(((upperHeight! / 30.48)-(upperHeight! ~/ 30.48))*12).toInt().toString()}\"" ),
                          ),
                        )
                    ),
                    FilterListItem(icon: Icon(Icons.man_outlined),title: "BodyType",
                        widget: Flexible(
                          flex: 5,
                          child: Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 4.0, // gap between lines
                            children: [
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        HeavySet = !HeavySet;
                                      });
                                    }, child: Text('HeavySet'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (HeavySet == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(onPressed: () {
                                    setState(() {
                                      Stocky = !Stocky;
                                    });

                                  }, child: Text('Stocky'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (Stocky == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(onPressed: () {
                                    setState(() {
                                      setState(() {
                                        AFewExtraPounds = !AFewExtraPounds;
                                      });
                                    });
                                  }, child: Text('AFewExtraPounds'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (AFewExtraPounds == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(onPressed: () {
                                    setState(() {
                                      setState(() {
                                        Average = !Average;
                                      });
                                    });
                                  }, child: Text('Average'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (Average == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(onPressed: () {
                                    setState(() {
                                      setState(() {
                                        Athletic = !Athletic;
                                      });
                                    });
                                  }, child: Text('Athletic'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (Athletic == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ElevatedButton(onPressed: () {
                                    setState(() {
                                      setState(() {
                                        Slender = !Slender;
                                      });
                                    });
                                  }, child: Text('Slender'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (Slender == false) ? Colors.grey : Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    ListTile(
                      //leading: Icon(Icons.man_outlined),
                      title: Text("You will only see people who match these filters, and you will only be shown to people who's filters you match."),
                    ),
                    ListTile(
                      //leading: Icon(Icons.man_outlined),
                      title: Text('Their dating goal will match your selection.'),
                    ),
                  ],
                ),
              ),
              Container(
                height: availableHeight*0.1,
                color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {},
                    ),
                    Row(
                      children: [
                        Text("Metric"),
                        Switch(value: metricImperial, onChanged: (value) {
                            setState(() {
                              metricImperial = value;
                            });
                          },
                          activeColor: Colors.pinkAccent,
                          inactiveTrackColor: Color.fromRGBO(38, 38, 38, 0.4),
                          activeTrackColor: Color.fromRGBO(38, 38, 38, 0.4),
                          inactiveThumbColor: Colors.blue,
                        ),
                        Text("Imperial")
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {},
                    )
                  ],
                ),
              )
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Container(
              width: 10,
            ),
            (title != null) ? Text(title!) : Text(''),
            Spacer(),
            widget,
          ],
        ),
      ),
    );
  }
}
