import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class INSocket {
  final double hmd;
  final double temp;

  INSocket(this.hmd, this.temp);
  @override
  String toString() {
    return 'hmd: $hmd, temp: $temp';
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  final List<INSocket> chartData = [
    INSocket(1, 35),
    INSocket(2, 28),
    INSocket(3, 34),
    INSocket(4, 32),
    INSocket(5, 40),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 9.0, left: 14.0),
            height: 300,
            child: SfCartesianChart(
              series: <ChartSeries>[
                LineSeries<INSocket, double>(
                  dataSource: chartData,
                  xValueMapper: (INSocket socket, _) => socket.hmd,
                  yValueMapper: (INSocket socket, _) => socket.temp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
