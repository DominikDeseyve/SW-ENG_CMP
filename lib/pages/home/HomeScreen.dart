import 'package:flutter/material.dart';

import 'CurvePainter.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        color: Color(0xFFF23B5F),
        child: CustomPaint(
          painter: CurvePainter(),
        ),
      ),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(
        margin: const EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 60.0),
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Willkommen",
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                "bei",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                "CMP",
                style: TextStyle(
                  fontSize: 60.0,
                  color: Color(0xFFF23B5F),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 50.0),
            height: 50.0,
            child: FlatButton(
              onPressed: () {},
              color: Color(0xFFF23B5F),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  Text(
                    "Playlist suchen",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 10.0,
              endIndent: 10.0,
              color: Colors.black87,
            )),
            Text("ODER",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                )),
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 10.0,
              endIndent: 10.0,
              color: Colors.black87,
            )),
          ]),
          Container(
            margin: EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 0.0),
            height: 50.0,
            child: FlatButton(
              onPressed: () {},
              color: Color(0xFFF23B5F),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  Text(
                    "Playlist erstellen",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    ]));
  }
}
