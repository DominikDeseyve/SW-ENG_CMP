import 'package:flutter/material.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/models/colors.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var color = ColorsClass();
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: CurvePainter(color.darkMode ? color.darkModeRed : color.lightModeRed, 0.395, 0.465, 0.395),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: CurvePainter(color.darkMode ? color.darkModeBlue : color.lightModeBlue, 0.38, 0.45, 0.38),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Willkommen",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  color: color.darkMode ? color.darkModeTitleText : color.lightModeTitleText,
                ),
              ),
              Text(
                "bei",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: color.darkMode ? color.darkModeTitleText : color.lightModeTitleText,
                ),
              ),
              Text(
                "CMP",
                style: TextStyle(
                  fontSize: 60.0,
                  color: color.darkMode ? color.darkModeTitleText : color.lightModeTitleText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 90.0),
            child: Text(
              "PLAYLIST",
              style: TextStyle(fontSize: 28.0),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 20.0),
            child: FlatButton(
              onPressed: () {},
              padding: const EdgeInsets.all(10),
              color: color.darkMode ? color.darkModeRed : color.lightModeRed,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.search,
                      size: 20.0,
                      color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText,
                    ),
                  ),
                  Text(
                    "Suchen",
                    style: TextStyle(fontSize: 18.0, color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText),
                  )
                ],
              ),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 30.0,
              endIndent: 10.0,
              color: color.darkMode ? color.darkModeBackgroundText : color.lightModeBackgroundText,
            )),
            Text("ODER",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: color.darkMode ? color.darkModeBackgroundText : color.lightModeBackgroundText,
                )),
            Expanded(
                child: Divider(
              thickness: 2.5,
              indent: 10.0,
              endIndent: 30.0,
              color: color.darkMode ? color.darkModeBackgroundText : color.lightModeBackgroundText,
            )),
          ]),
          Container(
            margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
            child: FlatButton(
              onPressed: () {},
              padding: const EdgeInsets.all(10),
              color: color.darkMode ? color.darkModeRed : color.lightModeRed,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                      color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText,
                    ),
                  ),
                  Text(
                    "Erstellen",
                    style: TextStyle(fontSize: 18.0, color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText),
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
