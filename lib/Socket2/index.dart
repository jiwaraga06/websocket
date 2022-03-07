import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class INSocket {
  final int indx;
  final double hmd;
  final double temp;

  INSocket(this.indx, this.hmd, this.temp);
  @override
  String toString() {
    return 'index:$indx, hmd: $hmd, temp: $temp';
  }
}

class INSocket2 {
  final String waktu;
  final double masuk;
  final double keluar;
  final double delt;
  final double hmd;
  final double temp;
  final double a;
  // final double b;

  INSocket2(this.waktu, this.masuk, this.keluar, this.delt, this.hmd, this.temp, this.a);
  @override
  String toString() {
    return 'waktu:$waktu, masuk: $masuk, keluar: $keluar,delta: $delt';
  }
}

class INSocket3 {
  // final String waktu;
  // final double masuk;
  // final double keluar;
  // final double delt;
  // final double hmd;
  // final double temp;
  final int count;
  final double a;
  final double b;

  INSocket3(this.count, this.a, this.b);

  @override
  String toString() {
    return 'a: $a, b: $b';
  }
}

class StatisEx {
  final String waktu;
  final double statis;

  StatisEx(this.waktu, this.statis);
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.110.249:81/'));
  final _channel2 = WebSocketChannel.connect(Uri.parse('ws://192.168.131.54:8081/'));
  final _channel3 = WebSocketChannel.connect(Uri.parse('ws://api2.sipatex.co.id:8687/'));
  final _channel4 = WebSocketChannel.connect(Uri.parse('ws://192.168.110.246:8118'));
  final _channel5 = WebSocketChannel.connect(Uri.parse('ws://192.168.50.95:8989/simulasi'));

  int counter = 0;
  List<INSocket2> listSc2 = [];
  List<INSocket3> listSc3 = [];
  List<StatisEx> listStatis = [];
  List array = [];
  var reverserList;
  var reverserListStatis;
  List pressure = [];
  var judul = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 2.5,
            child: Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)), color: Colors.white
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Color(0xff2c274c),
                  //     Color(0xff46426c),
                  //   ],
                  //   begin: Alignment.bottomCenter,
                  //   end: Alignment.topCenter,
                  // ),
                  ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 37,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            LineChartData(
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  textDirection: TextDirection.rtl,
                                  showTitles: true,
                                  interval: 1,
                                  getTextStyles: (context, value) => const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                rightTitles: SideTitles(showTitles: true),
                                leftTitles: SideTitles(showTitles: false),
                                topTitles: SideTitles(showTitles: false),
                              ),
                              minX: 0,
                              maxX: 20,
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.transparent),
                                  right: BorderSide(color: Colors.grey),
                                  top: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              lineBarsData: <LineChartBarData>[
                                LineChartBarData(
                                  isCurved: true,
                                  curveSmoothness: 0,
                                  preventCurveOverShooting: true,
                                  // colors: const [Color(0xff64b5f6)],
                                  barWidth: 2,
                                  isStrokeCapRound: false,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                  spots: const [
                                    FlSpot(0, 30),
                                    FlSpot(1, 35),
                                    FlSpot(2, 40),
                                    FlSpot(3, 38),
                                    FlSpot(4, 29),
                                    FlSpot(5, 45),
                                    FlSpot(6, 43),
                                    FlSpot(7, 43),
                                    FlSpot(8, 43),
                                    FlSpot(9, 43),
                                    FlSpot(10, 80),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: _channel3.stream,
            builder: (context, snapshot) {
              // print(snapshot.data);
              var socket = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 500,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Text(snapshot.error.toString()),
                  ],
                );
              } else {
                var js = jsonDecode(socket.toString());
                // print(js.toString().split(',')[3].split(':')[1].substring(1));
                // print(js.toString().split(',')[3].split(':')[1].substring(1).characters.take(js.toString().split(',')[3].split(':')[1].substring(1).length-1).toString().split(';'));
                var trimTemp = js['temperatur'].toString().split(';');
                var trimServer = js['ruang_server'].toString().split(';');
                // var trimA =js.toString().split(',')[3].split(' ')[2].characters.take(js.toString().split(',')[3].split(' ')[2].length - 1).toString().split(';');
                var trimA = js
                    .toString()
                    .split(',')[3]
                    .split(':')[1]
                    .substring(1)
                    .characters
                    .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                    .toString()
                    .split(';');
                var temperatur = js['temperatur'].toString().split(';');
                var ruang_server = js['ruang_server'].toString().split(';');
                var time = js['waktu_terkini'].toString().split(' ');
                var pak_fajar = js
                    .toString()
                    .split(',')[3]
                    .split(':')[1]
                    .substring(1)
                    .characters
                    .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                    .toString()
                    .split(';');
                if (listSc2.length >= 21) {
                  // listSc2.removeRange(0, 1);
                  listSc2.removeAt(0);
                  // listSc2.remove(0);
                }
                if (listStatis.length >= 21) {
                  listSc2.removeAt(0);
                  // listStatis.removeRange(0, 1);
                }
                if (array.length >= 21) {
                  array.removeAt(0);
                  // listStatis.removeRange(0, 1);
                }
                var variable = js.toString().split(',')[3].split(':')[0];
                judul = variable.toString();
                var a = {
                  "waktu": counter++,
                  "masuk": Random().nextInt(30),
                  "keluar": 0,
                  "delt": 0,
                  "hmd": 0,
                  "tmp": 0,
                };
                array.add(a);
                if (trimTemp.length == 1 && trimServer.length == 1 && trimA.length == 1) {
                  var time = js['waktu_terkini'].toString().split(' ');
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, 0, 0, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));

                  // print(array);
                } else if (trimTemp.length != 1 && trimServer.length == 1 && trimA.length == 1) {
                  var temperatur = js['temperatur'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, 0, 0, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length != 1 && trimA.length == 1) {
                  var ruang_server = js['ruang_server'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, _hmd, _tmp, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length == 1 && trimA.length != 1) {
                  var time = js['waktu_terkini'].toString().split(' ');
                  var pak_fajar = js
                      .toString()
                      .split(',')[3]
                      .split(':')[1]
                      .substring(1)
                      .characters
                      .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                      .toString()
                      .split(';');
                  var a = double.parse(pak_fajar[0]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, 0, 0, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length == 1 && trimA.length != 1) {
                  var temperatur = js['temperatur'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var pak_fajar = js
                      .toString()
                      .split(',')[3]
                      .split(':')[1]
                      .substring(1)
                      .characters
                      .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                      .toString()
                      .split(';');
                  var a = double.parse(pak_fajar[0]);
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, 0, 0, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length != 1 && trimA.length != 1) {
                  var ruang_server = js['ruang_server'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var pak_fajar = js
                      .toString()
                      .split(',')[3]
                      .split(':')[1]
                      .substring(1)
                      .characters
                      .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                      .toString()
                      .split(';');
                  var a = double.parse(pak_fajar[0]);
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, _hmd, _tmp, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length != 1 && trimA.length == 1) {
                  var temperatur = js['temperatur'].toString().split(';');
                  var ruang_server = js['ruang_server'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, _hmd, _tmp, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length != 1 && trimA.length != 1) {
                  var temperatur = js['temperatur'].toString().split(';');
                  var ruang_server = js['ruang_server'].toString().split(';');
                  var time = js['waktu_terkini'].toString().split(' ');
                  var pak_fajar = js
                      .toString()
                      .split(',')[3]
                      .split(':')[1]
                      .substring(1)
                      .characters
                      .take(js.toString().split(',')[3].split(':')[1].substring(1).length - 1)
                      .toString()
                      .split(';');
                  var a = double.parse(pak_fajar[0]);
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, _hmd, _tmp, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                }
                // print(listSc2);
                Iterable reverseList = listSc2.reversed;
                Iterable reverseList2 = listStatis.reversed;
                reverserList = reverseList.toList();
                reverserListStatis = reverseList2.toList();
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 3,
                      child: Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)), color: Colors.white
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Color(0xff2c274c),
                            //     Color(0xff46426c),
                            //   ],
                            //   begin: Alignment.bottomCenter,
                            //   end: Alignment.topCenter,
                            // ),
                            ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                    child: LineChart(
                                      LineChartData(
                                        lineTouchData: LineTouchData(
                                          handleBuiltInTouches: true,
                                          touchTooltipData: LineTouchTooltipData(
                                            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                                          ),
                                        ),
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                            textDirection: TextDirection.rtl,
                                            showTitles: true,
                                            interval: 1,
                                            getTextStyles: (context, value) => const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          rightTitles: SideTitles(showTitles: true),
                                          leftTitles: SideTitles(showTitles: false),
                                          topTitles: SideTitles(showTitles: false),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            bottom: BorderSide(color: Colors.black),
                                            left: BorderSide(color: Colors.transparent),
                                            right: BorderSide(color: Colors.grey),
                                            top: BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        lineBarsData: <LineChartBarData>[
                                          LineChartBarData(
                                              // isCurved: true,
                                              curveSmoothness: 0,
                                              preventCurveOverShooting: true,
                                              // colors: const [Color(0xff64b5f6)],
                                              barWidth: 2,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(show: false),
                                              belowBarData: BarAreaData(show: false),
                                              spots: array.map((e) {
                                                return FlSpot(e['waktu'], e['masuk']);
                                              }).toList())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.indigo,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Humidity"),
                                ruang_server.length == 1 ? Text(ruang_server[0].toString()) : Text(ruang_server[0].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.green[700],
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Temperatur"),
                                ruang_server.length == 1 ? Text(ruang_server[0].toString()) : Text(ruang_server[1].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.lightBlue,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("IN"),
                                temperatur.length == 1 ? Text(temperatur[0].toString()) : Text(temperatur[0].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.red[700],
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("OUT"),
                                temperatur.length == 1 ? Text(temperatur[0].toString()) : Text(temperatur[1].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.amber,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("DELTA"),
                                temperatur.length == 1 ? Text(temperatur[0].toString()) : Text(temperatur[2].toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.brown,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                Text(judul),
                                trimA.length == 1 ? Text(trimA[0].toString()) : Text(trimA[0].toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.black,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Nilai Minimum"),
                                const Text("3.25"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
