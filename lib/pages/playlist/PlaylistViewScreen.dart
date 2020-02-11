import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistViewScreen extends StatefulWidget {
  Playlist _playlist;

  PlaylistViewScreen(this._playlist);

  _PlaylistViewScreenState createState() => _PlaylistViewScreenState();
}

class _PlaylistViewScreenState extends State<PlaylistViewScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          title: Text(this.widget._playlist.name),
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
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180.0,
                        height: 180.0,
                        margin: EdgeInsets.only(top: 35.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (this.widget._playlist.imageURL != null
                                ? NetworkImage(this.widget._playlist.imageURL)
                                : AssetImage('assets/images/playlist.jpg')),
                          ),
                        ),
                      ),
                      Text(this.widget._playlist.name),
                      Text("erstellt von ..." /* + this.widget._playlist...*/),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: FlatButton(
                          onPressed: () {},
                          padding: const EdgeInsets.all(10),
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Icon(
                                  Icons.person_add,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Teilnehmen",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      OutlineButton(onPressed: () {}, child: ,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
