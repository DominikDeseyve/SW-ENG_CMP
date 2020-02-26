import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkmode;

  String _username;

  void initState() {
    _darkmode = Controller().authentificator.user.settings.darkMode;

    _username = Controller().authentificator.user.username;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Einstellungen",
                style: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 7,
              color: Controller().theming.accent,
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: false,
        primary: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/settings/profile').then((value) {
                  setState(() {
                    //this._userImage = Controller().authentificator.user.imageURL;
                    this._username = Controller().authentificator.user.username;
                  });
                });
              },
              child: ListTile(
                leading: UserAvatar(Controller().authentificator.user),
                title: Text(
                  _username,
                  style: TextStyle(
                    fontSize: 18,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                subtitle: Text(
                  "Profil anzeigen",
                  style: TextStyle(
                    fontSize: 14,
                    color: Controller().theming.tertiary,
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Controller().theming.tertiary,
                ),
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
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Controller().theming.fontPrimary,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_darkmode == true) {
                        Controller().theming.initLight();

                        // Darkmode in Firebase speichern

                        _darkmode = false;
                      } else {
                        Controller().theming.initDark();
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
                                color: Controller().theming.fontPrimary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Switch(
                                activeColor: Controller().theming.accent,
                                inactiveTrackColor: Controller().theming.tertiary,
                                value: _darkmode,
                                onChanged: (value) async {
                                  _darkmode = value;
                                  Controller().authentificator.user.settings.darkMode = value;
                                  await Controller().firebase.updateSettings();

                                  DynamicTheme.of(context).setState(() {
                                    if (_darkmode == false) {
                                      Controller().theming.initLight();
                                    } else {
                                      Controller().theming.initDark();
                                    }
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
                                color: Controller().theming.fontPrimary,
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
                                onTap: () {
                                  DynamicTheme.of(context).setState(() {
                                    Controller().translater.switchLanguage('ENGLISH');
                                  });
                                },
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
                                onTap: () {
                                  DynamicTheme.of(context).setState(() {
                                    Controller().translater.switchLanguage('GERMAN');
                                  });
                                },
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
              color: Controller().theming.accent,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.directions_run,
                      size: 20.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  ),
                  Text(
                    "Abmelden",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
