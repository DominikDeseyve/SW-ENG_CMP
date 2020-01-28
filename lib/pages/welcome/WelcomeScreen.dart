import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white70,
        width: MediaQuery.of(context)
            .size
            .width, //definiert die Breite der App auf den Bildschirm
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
////////////////////////////////////////////////////////////////////////////////
// Background Circles
////////////////////////////////////////////////////////////////////////////////
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.7),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(80.0),
                        bottomRight: const Radius.circular(180.0)),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.9),
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(500.0),
                      bottomRight: const Radius.circular(100.0),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(180.0),
                        bottomRight: const Radius.circular(360.0)),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.5),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(180.0),
                        bottomRight: const Radius.circular(360.0)),
                  ),
                ),

////////////////////////////////////////////////////////////////////////////////
// Titel with 2. Titel
////////////////////////////////////////////////////////////////////////////////

                Positioned(
                  left: 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "CMP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 120.0,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Connected Musik Playlist".toUpperCase(),
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

////////////////////////////////////////////////////////////////////////////////
// LogIn und Registrieren Button
////////////////////////////////////////////////////////////////////////////////
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                          top: 60.0,
                          right: 20.0,
                          bottom: 20.0,
                          left: 20.0,
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          height: 50.0,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          textColor: Colors.black54,
                          color: Colors.white,
                          child: Text(
                            "login".toUpperCase(),
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.all(20.0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          height: 50.0,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          textColor: Colors.black54,
                          color: Colors.white,
                          child: Text(
                            "registrieren".toUpperCase(),
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
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

void paint(Canvas canvas, Size size) {
  var paint = Paint();
  paint.color = Colors.redAccent;
  paint.style = PaintingStyle.fill; // Change this to fill

  var path = Path();

  path.moveTo(0, size.height * 0.84);
  path.quadraticBezierTo(
      size.width / 2, size.height * 1, size.width, size.height * 0.84);
  path.lineTo(size.width, 0);
  path.lineTo(0, 0);

  canvas.drawPath(path, paint);
}
