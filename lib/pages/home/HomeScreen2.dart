import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';

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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: CurvePainter(Colors.redAccent, 0.015, 0.015, 0.015),
            ),
          ),
          Container(
            child: ListView(children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "erstellte Playlists",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Colors.redAccent,
                      ),
                      // Hier kommt das entsprechende Widget hin
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 100.0,
                                  height: 100.0,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/playlist.jpg')))),
                              Text(
                                "Event 1",
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 100.0,
                                  height: 100.0,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/playlist.jpg')))),
                              Text(
                                "Event 1",
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 100.0,
                                  height: 100.0,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/playlist.jpg')))),
                              Text(
                                "Event 1",
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  width: 100.0,
                                  height: 100.0,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/playlist.jpg')))),
                              Text(
                                "Event 1",
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
