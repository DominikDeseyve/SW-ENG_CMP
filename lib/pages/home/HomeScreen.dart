import 'dart:math';

import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text("Connected Music Playlist"),
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
              painter: CurvePainter(Colors.redAccent, 0.015, 0.015, 0.015),
            ),
          ),
          //kompletter Bildschirm
          Container(
            child: ListView(
              children: <Widget>[
                //erstellte Playlists
                Container(
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "erstellte Playlists",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Color(0xFF253A4B),
                      ),
                    ],
                  ),
                ),
                //Die ganzen Events
                Container(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //beigetretene Playlists
                Container(
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "beigetretene Playlists",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w500),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Color(0xFF253A4B),
                      ),
                    ],
                  ),
                ),
                //Die ganzen Events
                Container(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      //Einzelner Event
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: 110.0,
                                height: 110.0,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/playlist.jpg')))),
                            Text(
                              "Event 1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                    ],
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
