import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/TinyLoader.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _username;
  bool _darkmode;
  int _crossfade;
  int _userCrossfade;

  PackageInfo _packageInfo;

  void initState() {
    super.initState();
    _username = Controller().authentificator.user.username;
    _darkmode = Controller().authentificator.user.settings.darkMode;
    _crossfade = Controller().authentificator.user.settings.crossfade;

    if (_crossfade == null) {
      _crossfade = 0;
    }
    _userCrossfade = _crossfade;

    this._packageInfo = new PackageInfo();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        this._packageInfo = value;
      });
    });
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
                Controller().translater.language.getLanguagePack("settings"),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
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
                        Controller().translater.language.getLanguagePack("show_profile"),
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
                SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Controller().theming.accent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          width: 20,
                          height: 15,
                        ),
                        SizedBox(width: 15),
                        Text(
                          Controller().translater.language.getLanguagePack("display_settings"),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Controller().theming.fontPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                        TinyLoader.show(context, 'Theming wird gewechselt');
                                        Controller().authentificator.user.settings.darkMode = value;
                                        await Controller().firebase.updateSettings();

                                        DynamicTheme.of(context).setState(() {
                                          if (_darkmode == false) {
                                            Controller().theming.initLight();
                                          } else {
                                            Controller().theming.initDark();
                                          }
                                        });
                                        TinyLoader.hide();
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
                                    Controller().translater.language.getLanguagePack("language"),
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
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                width: (MediaQuery.of(context).size.width / 2) - 40,
                                child: Text(
                                  "Crossfade",
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
                                child: Slider(
                                  value: _crossfade.toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      _crossfade = value.toInt();
                                    });
                                  },
                                  onChangeEnd: (value) {
                                    if (value.toInt() != _userCrossfade) {
                                      Controller().authentificator.user.settings.crossfade = value.toInt();
                                      Controller().firebase.updateSettings();
                                    }
                                  },
                                  divisions: 20,
                                  activeColor: Controller().theming.accent,
                                  inactiveColor: Controller().theming.tertiary,
                                  label: _crossfade.toString() + 's',
                                  min: 0,
                                  max: 20,
                                ),
                              ),
                            ),
                          ],
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
                          Controller().translater.language.getLanguagePack("logout"),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Version " + _packageInfo.version.toString(),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Buildnummer: " + _packageInfo.buildNumber.toString(),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                        fontSize: 15,
                      ),
                    ),
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
