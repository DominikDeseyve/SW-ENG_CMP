import 'package:cmp/pages/navigation.dart';
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
              Navigator.of(context).pushReplacementNamed('/root', arguments: Navigation.home);
            },
            child: Icon(
              Icons.close,
              color: Controller().theming.fontSecondary,
            ),
          ),
        ),
      ),
      body: ListView(
        //shrinkWrap: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.31,
                child: CustomPaint(
                  painter: CurvePainter(Controller().theming.accent, 0.745, 1, 0.745),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: CustomPaint(
                  painter: CurvePainter(Controller().theming.primary, 0.74, 1, 0.74),
                ),
              ),
              Container(
                //color: Colors.yellow,
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 0.27,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Controller().translater.language.getLanguagePack("welcome"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34.0,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                    Text(
                      Controller().translater.language.getLanguagePack("to"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                    Text(
                      Controller().translater.language.getLanguagePack("cmp"),
                      style: TextStyle(
                        fontSize: 46.0,
                        color: Controller().theming.fontSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
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
            margin: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
            child: FlatButton(
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/root', arguments: Navigation.search);
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
                      Icons.search,
                      size: 20.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  ),
                  Text(
                    Controller().translater.language.getLanguagePack("search"),
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
                Controller().translater.language.getLanguagePack("or"),
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
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/root', arguments: Navigation.create);
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
                      Icons.add,
                      size: 20.0,
                      color: Controller().theming.fontSecondary,
                    ),
                  ),
                  Text(
                    Controller().translater.language.getLanguagePack("create"),
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
