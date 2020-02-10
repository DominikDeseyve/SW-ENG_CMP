import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var color = ColorsClass();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.darkMode ? color.darkModeBackground : color.lightModeBackground,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(color.darkMode ? color.darkModeRed : color.lightModeRed, 0.25, 0.325, 0.25),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(color.darkMode ? color.darkModeBlue: color.lightModeBlue, 0.235, 0.31, 0.235),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 35.0),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text(
                    "Einstellungen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      color: color.darkMode ? color.darkModeTitleText : color.lightModeTitleText,
                    ),
                  ),
                ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
                  child: Material(
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    child: Ink.image(
                      image: AssetImage('assets/images/profilbild.webp'),
                      fit: BoxFit.cover,
                      width: 150.0,
                      height: 150.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    child: FlatButton(
                      color: color.darkMode ? color.darkModeRed : color.lightModeRed,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Bild +",
                            style: TextStyle(fontSize: 20.0, color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText),
                          )
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200,
                          child: FlatButton(
                            color: color.darkMode ? color.darkModeRed : color.lightModeRed,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  color.darkMode ? 'Dark mode' : 'Light mode',
                                  style: TextStyle(fontSize: 20.0, color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText),
                                )
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                color.darkMode = !color.darkMode;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: color.darkMode ? color.darkModeBackgroundText : color.lightModeBackgroundText,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200,
                          child: FlatButton(
                            color: color.darkMode ? color.darkModeRed : color.lightModeRed,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              'Abmelden',
                              style: TextStyle(fontSize: 20.0, color: color.darkMode ? color.darkModeButtonText : color.lightModeButtonText),
                            ),
                            onPressed: () async {
                              await Controller().authentificator.signOut();
                              Navigator.of(context, rootNavigator: true).pushReplacementNamed('/welcome');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      )
    );
  }
}
