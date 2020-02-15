import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/pages/playlist/tabs/DetailScreen.dart';
import 'package:cmp/pages/playlist/tabs/RequestsScreen.dart';
import 'package:cmp/pages/playlist/tabs/SubscriberScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistDetailScreen extends StatefulWidget {
  Playlist _playlist;

  PlaylistDetailScreen(this._playlist);

  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: (Controller().authentificator.user.userID != null /*this.widget._playlist.creator.userID*/ ? 3 : 2),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF253A4B),
          bottom: TabBar(
            indicator: BoxDecoration(),
            tabs: (Controller().authentificator.user.userID != null /*this.widget._playlist.creator.userID*/ ? [
                    Tab(
                      text: "Details",
                      icon: Icon(Icons.info),
                    ),
                    Tab(
                      text: "Teilnehmer",
                      icon: Icon(Icons.people),
                    ),
                    Tab(
                      text: "Anfragen",
                      icon: Icon(Icons.person_add),
                    ),
                  ]
                : [
                    Tab(
                      text: "Details",
                      icon: Icon(Icons.info),
                    ),
                    Tab(
                      text: "Teilnehmer",
                      icon: Icon(Icons.people),
                    ),
                  ]),
          ),
          title: Text("Informationen zu " + this.widget._playlist.name),
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
            //kompletter Bildschirm
            Container(
              padding: EdgeInsets.only(top: 15),
              child: TabBarView(
                children: <Widget>[
                  // Details View
                  DetailScreen(this.widget._playlist),

                  // Teilnehmer View
                  SubscriberScreen(this.widget._playlist),

                  (Controller().authentificator.user.userID != null /*this.widget._playlist.creator.userID*/ ?
                      // Anfragen View
                      RequestScreen(this.widget._playlist)
                      : Container()),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.01,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
