import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey : Colors.white,
      body: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Einstellungen",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
              child: Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: 2.5,
                  indent: 10.0,
                  endIndent: 10.0,
                  color: Colors.black87,
                )),
              ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
              child: Image.asset(
                'assets/images/profilbild.webp',
                height: 100,
                width: 100,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                child: FlatButton(
                  color: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Bild +",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
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
                  margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 200,
                      child: FlatButton(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              darkMode ? 'Dark mode' : 'Light mode',
                              style: TextStyle(fontSize: 20.0, color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            darkMode = !darkMode;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'BetziSoftware',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 200,
                      child: FlatButton(
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(
                          'Abmelden',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
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
    );
  }
}
