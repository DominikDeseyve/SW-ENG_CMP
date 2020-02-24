import 'dart:io';

import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkmode;
  var _userImage;
  String _username;

  void initState() {
    _darkmode = Controller().authentificator.user.darkmode;
    _userImage = Controller().authentificator.user.imageURL;
    _username = Controller().authentificator.user.username;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text("Einstellungen"),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: MediaQuery.of(context).size.height * 0.01,
              color: Colors.redAccent,
            ),
          ),
        ),
        child: ListView(
          shrinkWrap: false,
          primary: true,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/settings/profile').then((value) {
                    setState(() {
                      this._userImage = Controller().authentificator.user.imageURL;
                      this._username = Controller().authentificator.user.username;
                    });
                  });
                },
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (this._userImage == null ? AssetImage("assets/images/person.png") : NetworkImage(this._userImage)),
                      ),
                    ),
                  ),
                  title: Text(
                    _username,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "Profil anzeigen",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Allgemeines",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Color(0xFF253A4B),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_darkmode == true) {
                          _darkmode = false;
                        } else {
                          _darkmode = true;
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              width: 120,
                              child: Text(
                                "DarkMode",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Switch(
                                  activeColor: Colors.redAccent,
                                  value: _darkmode,
                                  onChanged: (value) {
                                    setState(() {
                                      _darkmode = value;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              width: 120,
                              child: Text(
                                "Sprache",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/images/flags/united-kingdom.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/images/flags/germany.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: FlatButton(
                onPressed: () async {
                  await Controller().authentificator.signOut();
                  Navigator.of(context, rootNavigator: true).pushReplacementNamed('/welcome');
                },
                padding: const EdgeInsets.all(10),
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.directions_run,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Abmelden",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
