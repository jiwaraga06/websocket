import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}

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

class Socket {
  final String waktu;
  final double cooling;
  final double keeping;
  final double heating;
  final double off;

  Socket(this.waktu, this.cooling, this.keeping, this.heating, this.off);

  @override
  String toString() {
    return 'waktu: $waktu, cooling: $cooling,keeping: $keeping,heating: $heating,off: $off';
  }
}

class SocketChart extends StatefulWidget {
  const SocketChart({Key? key}) : super(key: key);

  @override
  _SocketChartState createState() => _SocketChartState();
}

class _SocketChartState extends State<SocketChart> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.110.249:81/'));
  final _channel2 = WebSocketChannel.connect(Uri.parse('ws://192.168.131.54:8081/'));
  final _channel3 = WebSocketChannel.connect(Uri.parse('ws://api2.sipatex.co.id:8687/'));
  final _channellokal = WebSocketChannel.connect(Uri.parse('ws://192.168.119.3:8687/'));
  final _channel4 = WebSocketChannel.connect(Uri.parse('ws://192.168.110.246:8118'));
  final _channel5 = WebSocketChannel.connect(Uri.parse('ws://192.168.50.95:8989/simulasi'));

  int counter = 0;
  List<Socket> sockets = [];
  List<INSocket2> listSc2 = [];
  List<INSocket3> listSc3 = [];
  List<StatisEx> listStatis = [];
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
      // appBar: AppBar(
      //   title: const Text('Socket Chart'),
      // ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: _channellokal.stream,
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
                var statuszMesin = js['StatuszMesin'];
                // print(statuszMesin.length);
                // print("statuszMesin: " + js['StatuszMesin']);
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
                var cooling, heating, keeping, off;
                if (statuszMesin == "closed") {
                  sockets.add(Socket(time[1].toString(), 0, 0, 0, 0));
                  cooling = 'closed';
                  heating = 'closed';
                  keeping = 'closed';
                  off = 'closed';
                } else if (statuszMesin == 'opening') {
                  sockets.add(Socket(time[1].toString(), 0, 0, 0, 0));
                  cooling = 'opening';
                  heating = 'opening';
                  keeping = 'opening';
                  off = 'opening';
                } else {
                  var status = jsonDecode(js['StatuszMesin'].toString());
                  var sum = status[0]['jml_msn'] + status[1]['jml_msn'] + status[2]['jml_msn'] + status[3]['jml_msn'];
                  sockets.add(Socket(time[1].toString(), status[0]['jml_msn'] / sum * 10, status[1]['jml_msn'] / sum * 10, status[2]['jml_msn'] / sum * 10,
                      status[3]['jml_msn'] / sum * 10));
                  var cool = status[0]['jml_msn'] / sum * 100;
                  var keep = status[1]['jml_msn'] / sum * 100;
                  var heat = status[2]['jml_msn'] / sum * 100;
                  var of = status[3]['jml_msn'] / sum * 100;
                  cooling = '${status[0]['jml_msn']} - ${num.tryParse(cool.toString())?.toDouble().toStringAsFixed(2)}';
                  keeping = '${status[1]['jml_msn']} - ${num.tryParse(keep.toString())?.toDouble().toStringAsFixed(2)}';
                  heating = '${status[2]['jml_msn']} - ${num.tryParse(heat.toString())?.toDouble().toStringAsFixed(2)}';
                  off = '${status[3]['jml_msn']} - ${num.tryParse(of.toString())?.toDouble().toStringAsFixed(2)}';
                }
                //
                if (listSc2.length >= 21) {
                  // listSc2.removeRange(0, 1);
                  listSc2.removeAt(0);
                  // listSc2.remove(0);
                }
                if (listStatis.length >= 21) {
                  listStatis.removeAt(0);
                  sockets.removeAt(0);
                  // listStatis.removeRange(0, 1);
                }
                var variable = js.toString().split(',')[3].split(':')[0];
                judul = variable.toString();

                if (trimTemp.length == 1 && trimServer.length == 1 && trimA.length == 1) {
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, 0, 0, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length == 1 && trimA.length == 1) {
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, 0, 0, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length != 1 && trimA.length == 1) {
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, _hmd, _tmp, 0));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length == 1 && trimA.length != 1) {
                  var a = double.parse(pak_fajar[0]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, 0, 0, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length == 1 && trimA.length != 1) {
                  var a = double.parse(pak_fajar[0]);
                  var _in = double.parse(temperatur[0]);
                  var _out = double.parse(temperatur[1]);
                  var _delta = double.parse(temperatur[2]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), _in, _out, _delta, 0, 0, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length == 1 && trimServer.length != 1 && trimA.length != 1) {
                  var a = double.parse(pak_fajar[0]);
                  var _hmd = double.parse(ruang_server[0]);
                  var _tmp = double.parse(ruang_server[1]);
                  var wkt = time[1];
                  // print(temperatur);
                  listSc2.add(INSocket2(wkt.toString(), 0, 0, 0, _hmd, _tmp, a));
                  listStatis.add(StatisEx(wkt.toString(), 3.25));
                } else if (trimTemp.length != 1 && trimServer.length != 1 && trimA.length == 1) {
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
                Iterable reverseList = listSc2.reversed;
                Iterable reverseList2 = listStatis.reversed;
                reverserList = reverseList.toList();
                reverserListStatis = reverseList2.toList();
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 9.0, left: 14.0),
                      height: 250,
                      child: SfCartesianChart(
                        // crosshairBehavior: CrosshairBehavior(
                        //   enable: true,
                        //   activationMode: ActivationMode.singleTap,
                        // ),
                        title: ChartTitle(text: 'Temperatur'),
                        primaryXAxis: CategoryAxis(
                          labelPlacement: LabelPlacement.onTicks,
                          visibleMinimum: 0,
                          visibleMaximum: 20,
                          isInversed: true,
                          labelRotation: 20,
                        ),
                        primaryYAxis: NumericAxis(
                          isVisible: true,
                          opposedPosition: true,
                          placeLabelsNearAxisLine: true,
                        ),
                        series: <ChartSeries>[
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: 'Humidity',
                            width: 1.5,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.hmd,
                            color: Colors.indigo,
                          ),
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: 'Temperatur',
                            width: 1.5,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.temp,
                            color: Colors.green,
                          ),
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: 'IN',
                            width: 1.5,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.masuk,
                            color: Colors.lightBlue,
                          ),
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: 'OUT',
                            width: 1.5,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.keluar,
                            color: Colors.red[800],
                          ),
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: 'DELTA',
                            width: 1.5,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.delt,
                            color: Colors.amber,
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
                    Container(
                      margin: const EdgeInsets.only(top: 12.0, left: 14.0),
                      height: 310,
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Pressure'),
                        primaryXAxis: CategoryAxis(
                          labelPlacement: LabelPlacement.onTicks,
                          visibleMinimum: 0,
                          visibleMaximum: 20,
                          isInversed: true,
                          labelRotation: 20,
                        ),
                        primaryYAxis: NumericAxis(
                          maximum: 10,
                          isVisible: true,
                          opposedPosition: true,
                          placeLabelsNearAxisLine: true,
                        ),
                        series: <ChartSeries>[
                          SplineSeries<INSocket2, String>(
                            animationDuration: 0.5,
                            name: judul,
                            dataSource: reverserList,
                            xValueMapper: (INSocket2 sc, _) => sc.waktu.toString(),
                            yValueMapper: (INSocket2 sc, _) => sc.a,
                            color: Colors.brown,
                          ),
                          SplineSeries<StatisEx, String>(
                            animationDuration: 0.5,
                            name: 'Nilai Minimum',
                            dataSource: reverserListStatis,
                            xValueMapper: (StatisEx sc, _) => sc.waktu.toString(),
                            yValueMapper: (StatisEx sc, _) => sc.statis,
                            color: Colors.black,
                          ),
                          SplineSeries<Socket, String>(
                            animationDuration: 0.5,
                            name: 'COOLING',
                            dataSource: sockets,
                            xValueMapper: (Socket sc, _) => sc.waktu.toString(),
                            yValueMapper: (Socket sc, _) => sc.cooling,
                            color: Colors.green[700],
                          ),
                          SplineSeries<Socket, String>(
                            animationDuration: 0.5,
                            name: 'KEEPING',
                            dataSource: sockets,
                            xValueMapper: (Socket sc, _) => sc.waktu.toString(),
                            yValueMapper: (Socket sc, _) => sc.keeping,
                            color: Colors.yellow[600],
                          ),
                          SplineSeries<Socket, String>(
                            animationDuration: 0.5,
                            name: 'HEATING',
                            dataSource: sockets,
                            xValueMapper: (Socket sc, _) => sc.waktu.toString(),
                            yValueMapper: (Socket sc, _) => sc.heating,
                            color: Colors.red,
                          ),
                          SplineSeries<Socket, String>(
                            animationDuration: 0.5,
                            name: 'OFF',
                            dataSource: sockets,
                            xValueMapper: (Socket sc, _) => sc.waktu.toString(),
                            yValueMapper: (Socket sc, _) => sc.off,
                            color: Colors.deepPurple[600],
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
                          const SizedBox(width: 200),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 3,
                                  width: 20,
                                  color: Colors.red,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Heating"),
                                Text(heating.toString() + ' %'),
                                // statuszMesin.length == 4 ? Text(statuszMesin[2]['jml_msn'].toString()) : Text(statuszMesin.toString()),
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
                                  color: Colors.yellow[600],
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Keeping"),
                                Text(keeping.toString() + ' %'),
                                // statuszMesin.length == 4 ? Text(statuszMesin[1]['jml_msn'].toString()) : Text(statuszMesin.toString()),
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
                                const Text("Cooling"),
                                Text(cooling.toString() + ' %')
                                // statuszMesin.length == 4 ? Text(statuszMesin[0]['jml_msn'].toString()) : Text(statuszMesin.toString()),
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
                                  color: Colors.deepPurple[600],
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                const Text("Off"),
                                Text(off.toString() + ' %')
                                // statuszMesin.length == 4 ? Text(statuszMesin[3]['jml_msn'].toString()) : Text(statuszMesin.toString()),
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
