import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          title: Center(
            child: Text(
              'CMP',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.275, 0.345, 0.275),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Color(0xFF253A4B), 0.26, 0.33, 0.26),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50.0),
            child: ListView(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 90.0),
                child: Text(
                  "PLAYLIST",
                  style: TextStyle(fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
