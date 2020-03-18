import 'package:flutter/material.dart';
import 'package:cmp/widgets/CurvePainter.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.40, 0.46, 0.40),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Color(0xFF253A4B), 0.39, 0.45, 0.39),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Container(
                        width: 100,
                        child: Image(
                          image: AssetImage('assets/icons/icon-blue-256x256.png'),
                        ),
                      ),
                      SizedBox(height: 5),
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
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.08, 20, 20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        indent: 30.0,
                        endIndent: 10.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "ODER",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        indent: 10.0,
                        endIndent: 30.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Registrieren",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
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
