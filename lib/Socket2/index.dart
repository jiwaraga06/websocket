import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class INSocket {
  final String nama;
  final double nilai;

  INSocket(this.nama, this.nilai);

  @override
  String toString() {
    return '{Nama: $nama, Nilai: $nilai}';
  }
}

class SocketPrt {
  final String nama;
  final double nilai;

  SocketPrt(this.nama, this.nilai);

  @override
  String toString() {
    return '{Nama: $nama, Nilai: $nilai}';
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.119.3:2880/ws/JumJo'));
  List<INSocket> chartData = [];
  List<SocketPrt> chartPrt = [];
  late TooltipBehavior _tooltipBehaviorDye;
  late TooltipBehavior _tooltipBehaviorPrt;

  @override
  void initState() {
    _tooltipBehaviorDye = TooltipBehavior(enable: true);
    _tooltipBehaviorPrt = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                var data = snapshot.data;
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
                  var json = jsonDecode(data.toString());
                  // dye
                  var jodye = double.parse(json[0]['JODye'].toString());
                  var kpdye = double.parse(json[0]['KPDye'].toString());
                  var rldye = double.parse(json[0]['RLDye'].toString());
                  var hasilJO = jodye - kpdye;
                  var hasilKP = kpdye - rldye;
                  var hasilRL = rldye;
                  var jumlah = hasilJO + hasilKP + hasilRL;
                  var perJO = hasilJO / jumlah * 100;
                  var perKP = hasilKP / jumlah * 100;
                  var perRL = hasilRL / jumlah * 100;
                  chartData.add(INSocket('JODYE', perJO));
                  chartData.add(INSocket('KPDYE', perKP));
                  chartData.add(INSocket('RLDYE', perRL));
                  // prt
                  var joprt = double.parse(json[0]['JOPrt'].toString());
                  var kpprt = double.parse(json[0]['KPPrt'].toString());
                  var rlprt = double.parse(json[0]['RLPrt'].toString());
                  var hasilJOPrt = joprt - kpprt;
                  var hasilKPPrt = kpprt - rlprt;
                  var hasilRLPrt = rlprt;
                  var jumlahPrt = hasilJOPrt + hasilKPPrt + hasilRLPrt;
                  var perJOPrt = hasilJOPrt / jumlahPrt * 100;
                  var perKPPrt = hasilKPPrt / jumlahPrt * 100;
                  var perRLPrt = hasilRLPrt / jumlahPrt * 100;
                  chartPrt.add(SocketPrt("JOPRT", perJOPrt));
                  chartPrt.add(SocketPrt("KPPRT", perKPPrt));
                  chartPrt.add(SocketPrt("RLPRT", perRLPrt));
                  //
                  if (chartData.length == 6) {
                    chartData.removeAt(0);
                    chartData.removeAt(0);
                    chartData.removeAt(0);
                  }
                  if (chartPrt.length == 6) {
                    chartPrt.removeAt(0);
                    chartPrt.removeAt(0);
                    chartPrt.removeAt(0);
                  }
                  print("DYE : $chartData");
                  print("PRT : $chartPrt");
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: SfCircularChart(
                          tooltipBehavior: _tooltipBehaviorDye,
                          palette: const <Color>[
                            Colors.blue,
                            Color(0xFF14C38E),
                            Color(0xFF393E46),
                          ],
                          series: <CircularSeries>[
                            PieSeries<INSocket, String>(
                              dataSource: chartData,
                              xValueMapper: (INSocket data, _) => data.nama,
                              yValueMapper: (INSocket data, _) => data.nilai.roundToDouble(),
                              strokeWidth: 2,
                              explodeAll: true,
                              explodeOffset: '2%',
                              enableTooltip: true,
                              explode: true,
                              dataLabelSettings: const DataLabelSettings(
                                // isVisible: true,
                                showCumulativeValues: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 50,
                                  child: Icon(Icons.pie_chart, color: Colors.blue),
                                ),
                                const SizedBox(width: 50, child: Text("JODYE")),
                                Text(perJO.toStringAsFixed(1) + '%'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 50, child: Icon(Icons.pie_chart, color: Color(0xFF393E46))),
                                const SizedBox(width: 50, child: Text("RLDYE")),
                                Text(
                                  perRL.toStringAsFixed(1) + '%',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 50, child: Icon(Icons.pie_chart, color: Color(0xFF14C38E))),
                                const SizedBox(width: 50, child: Text("KPDYE")),
                                Text(
                                  perKP.toStringAsFixed(1) + '%',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: SfCircularChart(
                          tooltipBehavior: _tooltipBehaviorPrt,
                          palette: const <Color>[
                            Colors.blue,
                            Color(0xFF14C38E),
                            Color(0xFF393E46),
                          ],
                          series: <CircularSeries>[
                            PieSeries<SocketPrt, String>(
                              dataSource: chartPrt,
                              xValueMapper: (SocketPrt data, _) => data.nama,
                              yValueMapper: (SocketPrt data, _) => data.nilai.roundToDouble(),
                              strokeWidth: 2,
                              explodeAll: true,
                              explodeOffset: '2%',
                              enableTooltip: true,
                              explode: true,
                              dataLabelSettings: const DataLabelSettings(
                                // isVisible: true,
                                showCumulativeValues: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 50,
                                  child: Icon(Icons.pie_chart, color: Colors.blue),
                                ),
                                const SizedBox(width: 50, child: Text("JOPRT")),
                                Text(perJOPrt.toStringAsFixed(1) + '%'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 50, child: Icon(Icons.pie_chart, color: Color(0xFF393E46))),
                                const SizedBox(width: 50, child: Text("RLPRT")),
                                Text(
                                  perRLPrt.toStringAsFixed(1) + '%',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 50, child: Icon(Icons.pie_chart, color: Color(0xFF14C38E))),
                                const SizedBox(width: 50, child: Text("KPPRT")),
                                Text(
                                  perKPPrt.toStringAsFixed(1) + '%',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })
        ],
      ),
    );
  }
}
