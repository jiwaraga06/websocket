import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ClicksPerYear {
  final int year;
  final int clicks;

  ClicksPerYear(this.year, this.clicks);
}

class Socket3 extends StatefulWidget {
  @override
  _Socket3State createState() => _Socket3State();
}

class _Socket3State extends State<Socket3> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      ClicksPerYear(0, 12),
      ClicksPerYear(1, 22),
      ClicksPerYear(2, 30),
      ClicksPerYear(3, 30),
    ];
    var data2 = [
      ClicksPerYear(0, 5),
      ClicksPerYear(1, 26),
      ClicksPerYear(2, 35),
      ClicksPerYear(3, 45),
    ];

    var series = [
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        id: 'Clicks',
        data: data,
      ),
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        id: 'Clicks',
        data: data2,
      ),
    ];

    var chart = charts.LineChart(
      series,
      animationDuration: Duration(milliseconds: 1500),
      animate: true,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            // Text('$_counter', style: Theme.of(context).textTheme.display1),
            chartWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
