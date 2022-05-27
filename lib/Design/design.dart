import 'package:flutter/material.dart';

class DesignUI extends StatefulWidget {
  DesignUI({Key? key}) : super(key: key);

  @override
  State<DesignUI> createState() => _DesignUIState();
}

class _DesignUIState extends State<DesignUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5 - 30,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hallo,',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Senin, 1 Januari 2020',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 150,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(20.0)), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                        offset: const Offset(1, 3),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ],
      ),
    );
  }
}
