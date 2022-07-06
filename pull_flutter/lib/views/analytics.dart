import 'package:flutter/material.dart';
import 'package:pull_flutter/model/chart_series/developer_chart.dart';
import 'package:pull_flutter/model/chart_series/developer_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final List<DeveloperSeries> data = [

      DeveloperSeries(
        year: 2017,
        developers: 40000,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      DeveloperSeries(
        year: 2018,
        developers: 5000,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      DeveloperSeries(
        year: 2019,
        developers: 40000,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      DeveloperSeries(
        year: 2020,
        developers: 35000,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      DeveloperSeries(
        year: 2021,
        developers: 45000,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];

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
                    ListTile(
                      //leading: Icon(Icons.man_outlined),
                      title: Text('Yeet'),
                    ),
                    SizedBox(
                        child: DeveloperChart(data: data),
                      height: 100,
                      width: 100,
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