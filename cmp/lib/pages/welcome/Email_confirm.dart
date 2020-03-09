import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';

class MailConfirmScreen extends StatefulWidget {
  final String _email;
  MailConfirmScreen(this._email);

  _MailConfirmScreenState createState() => _MailConfirmScreenState();
}

class _MailConfirmScreenState extends State<MailConfirmScreen> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.275, 0.345, 0.275),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Color(0xFF253A4B), 0.26, 0.33, 0.26),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50.0),
            child: ListView(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "CMP",
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Connected Music Playlist",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 200.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 90.0),
                  child: Text(
                    "Fast geschafft",
                    style: TextStyle(fontSize: 35.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 90.0),
                  child: Text(
                    "Wir haben dir eine E-Mail an " + this.widget._email + " geschickt. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 90.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    height: 50.0,
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    child: Text(
                      "Email erneut senden".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    height: 50.0,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    child: Text(
                      "Weiter zu Login".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
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
