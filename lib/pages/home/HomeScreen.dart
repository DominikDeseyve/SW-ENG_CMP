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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: CurvePainter(Colors.redAccent, 0.415, 0.485, 0.415),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: CurvePainter(Color(0xFF253A4B), 0.4, 0.47, 0.4),
        ),
      ),
      Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 60.0),
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Willkommen\nbei",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ),
              Text(
                "CMP",
                style: TextStyle(
                  fontSize: 60.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(40.0, 90.0, 40.0, 0.0),
            child: Text(
              "PLAYLIST",
              style: TextStyle(fontSize: 28.0),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 20.0),
            child: FlatButton(
              onPressed: () {},
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  Text(
                    "Suchen",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 0.0,
              endIndent: 10.0,
              color: Colors.black87,
            )),
            Text("ODER",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                )),
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 10.0,
              endIndent: 0.0,
              color: Colors.black87,
            )),
          ]),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: FlatButton(
              onPressed: () {},
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  Text(
                    "Erstellen",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
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
