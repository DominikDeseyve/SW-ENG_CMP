import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:cmp/widgets/CurvePainter.dart';

class StartScreen extends StatefulWidget {
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Controller().theming.primary,
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/root');
            },
            child: Icon(
              Icons.close,
              color: Controller().theming.fontSecondary,
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
              painter: CurvePainter(Controller().theming.accent, 0.235, 0.305, 0.235),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Controller().theming.primary, 0.22, 0.29, 0.22),
            ),
          ),
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  //height: MediaQuery.of(context).size.height * 0.20,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Willkommen",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34.0,
                            color: Controller().theming.fontSecondary,
                          ),
                        ),
                        Text(
                          "bei",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            color: Controller().theming.fontSecondary,
                          ),
                        ),
                        Text(
                          "CMP",
                          style: TextStyle(
                            fontSize: 46.0,
                            color: Controller().theming.fontSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 90.0),
                  child: Text(
                    "PLAYLIST",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Controller().theming.fontPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                  child: FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    color: Controller().theming.accent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.search,
                            size: 20.0,
                            color: Controller().theming.fontSecondary,
                          ),
                        ),
                        Text(
                          "Suchen",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Controller().theming.fontSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2.5,
                        indent: 30.0,
                        endIndent: 10.0,
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                    Text(
                      "ODER",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2.5,
                        indent: 10.0,
                        endIndent: 30.0,
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    color: Controller().theming.accent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.add,
                            size: 20.0,
                            color: Controller().theming.fontSecondary,
                          ),
                        ),
                        Text(
                          "Erstellen",
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
          ),
        ],
      ),
    );
  }
}
