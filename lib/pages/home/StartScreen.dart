import 'package:flutter/material.dart';
import 'package:cmp/widgets/CurvePainter.dart';

class StartScreen extends StatefulWidget {
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/root');
            },
            child: Icon(Icons.close),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            // Add box decoration
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.0, 1.0],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.grey[400],
                  Colors.white,
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.235, 0.305, 0.235),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Color(0xFF253A4B), 0.22, 0.29, 0.22),
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
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "bei",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "CMP",
                          style: TextStyle(
                            fontSize: 46.0,
                            color: Colors.white,
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
                    style: TextStyle(fontSize: 28.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                  child: FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.search,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Suchen",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "ODER",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2.5,
                        indent: 10.0,
                        endIndent: 30.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(10),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.add,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Erstellen",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
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
