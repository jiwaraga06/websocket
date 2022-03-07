import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Socket {
  final int count;
  final double cooling;
  final double keeping;
  final double heating;
  final double off;

  Socket(this.count, this.cooling, this.keeping, this.heating, this.off);

  @override
  String toString() {
    return 'count: $count, cooling: $cooling,keeping: $keeping,heating: $heating,off: $off';
  }
}

class Socket4 extends StatefulWidget {
  Socket4({Key? key}) : super(key: key);

  @override
  State<Socket4> createState() => _Socket4State();
}

class _Socket4State extends State<Socket4> {
  final _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.119.3:2880/ws/StatusMesin2'));
  var res = [];
  var counter = 0;
  List<Socket> socket = [];
  void tester() async {
    var value = '0,12;1,24;2,40';
    var b = value.split(';');
    var isi = b[0].split(',');
    res.add(isi[1]);
    res.add(12);
    print(isi[1]);
  }

  @override
  void initState() {
    super.initState();
    tester();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          StreamBuilder(
              stream: _channel.stream,
              builder: (BuildContext context, snapshot) {
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
                  var data = snapshot.data;
                  var json = jsonDecode(data.toString());
                  socket.add(Socket(counter++, json[0]['jml_msn'], json[1]['jml_msn'], json[2]['jml_msn'], json[3]['jml_msn']));
                  if (socket.length >= 21) {
                    socket.removeAt(0);
                    // listStatis.removeRange(0, 1);
                  }
                  print(json);
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.only(top: 12.0, left: 14.0),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Mesin'),
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
                        SplineSeries<Socket, String>(
                          name: 'HEATING',
                          width: 1.5,
                          dataSource: socket,
                          xValueMapper: (Socket sc, _) => sc.count.toString(),
                          yValueMapper: (Socket sc, _) => sc.heating,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
