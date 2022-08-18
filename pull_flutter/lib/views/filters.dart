import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';

class FilterPage extends ConsumerStatefulWidget {
  FilterPage({
    Key? key,
    required this.onDone,
    this.cancelable = true,
    this.onCancel,
  }) : super(key: key);

  //pass in a callback for what should happen when the done button is pressed.
  //pass in a boolean of whether they should be able to cancel or not.
  final Function onDone;
  final bool cancelable;
  final Function? onCancel;

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}



class _FilterPageState extends ConsumerState<FilterPage> {
  bool metricImperial = false; //to use metric or imperial

  late Filters filters = Filters.basic();

  void getFilters() async{
    //make request to the server to get the filters.
    if(widget.cancelable == true){
      //this means that a filter should exist already
      //TODO retrieve the filters from the server.
      try {
        PullRepository repo = PullRepository(ref.read);
        Filters tempFilters = await repo.getFilterRequest();
        setState((){
          filters = tempFilters;
        });
      } catch (e) {
        //TODO show the user some error about their connectivity.
        print(e);
      }
    }
  }



  @override
  void initState() {
    //get the most recent filters from the server for that user.

    super.initState();
    getFilters();
  }



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
                    FilterListItem(icon: Icon(Icons.transgender),title: "Gender(s)",
                        widget: Row(
                          children: [
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        filters.menChecked = !filters.menChecked;
                                      });
                                    }, child: Text('Men'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (filters.menChecked == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                    filters.womenChecked = !filters.womenChecked;
                                  });

                                }, child: Text('Women'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (filters.womenChecked == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                      filters.nonBinaryChecked = !filters.nonBinaryChecked;
                                    });
                                  });
                                }, child: Text('Non-Binary'),
                                  style: ElevatedButton.styleFrom(
                                    primary: (filters.nonBinaryChecked == false) ? Colors.grey : Colors.lightBlueAccent,
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
                            values: RangeValues(filters.lowerAge.toDouble(),filters.upperAge.toDouble()),
                            onChanged: (values) {
                              setState(() {
                                filters.lowerAge = values.start.toInt();
                                filters.upperAge = values.end.toInt();
                              });
                            },
                            labels: RangeLabels(filters.lowerAge.round().toString(),filters.upperAge.round().toString()),
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
                            value: filters.maxDistance.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                filters.maxDistance = value.toInt();
                                //print(filters.maxDistance);
                              });
                            },
                            label: (metricImperial == false) ? "${filters.maxDistance.round().toString()} km" : "${(filters.maxDistance*0.621371).round().toString()} miles",
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
                            values: RangeValues(filters.lowerHeight.toDouble(),filters.upperHeight.toDouble()),
                            onChanged: (values) {
                              setState(() {
                                filters.lowerHeight = values.start.toInt();
                                filters.upperHeight = values.end.toInt();
                              });
                            },
                            labels: RangeLabels((metricImperial == false)? "${filters.lowerHeight.round()} cm" : "${(filters.lowerHeight~/30.48).round().toString()}\'${(((filters.lowerHeight / 30.48)-(filters.lowerHeight ~/ 30.48))*12).toInt().toString()}\""
                                , (metricImperial == false)? "${filters.upperHeight.round()} cm" : "${(filters.upperHeight~/30.48).round().toString()}\'${(((filters.upperHeight / 30.48)-(filters.upperHeight ~/ 30.48))*12).toInt().toString()}\"" ),
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
                                        filters.obese = !filters.obese;
                                      });
                                    }, child: Text('Obese'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (filters.obese == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                      filters.heavy = !filters.heavy;
                                    });

                                  }, child: Text('Heavy'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (filters.heavy == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                        filters.muscular = !filters.muscular;
                                      });
                                    });
                                  }, child: Text('Muscular'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (filters.muscular == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                        filters.average = !filters.average;
                                      });
                                    });
                                  }, child: Text('Average'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (filters.average == false) ? Colors.grey : Colors.lightBlueAccent,
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
                                        filters.lean = !filters.lean;
                                      });
                                    });
                                  }, child: Text('Lean'),
                                    style: ElevatedButton.styleFrom(
                                      primary: (filters.lean == false) ? Colors.grey : Colors.lightBlueAccent,
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
                    if(widget.cancelable && widget.onCancel != null) ...[
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => widget.onCancel!(context),
                      ),
                    ],
                    if(!widget.cancelable) ...[
                      SizedBox(width: 0,)
                    ],
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
                      onPressed: () => widget.onDone(context,ref,filters),
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
