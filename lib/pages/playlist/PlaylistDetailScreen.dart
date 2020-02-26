import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/pages/playlist/tabs/DetailScreen.dart';
import 'package:cmp/pages/playlist/tabs/RequestsScreen.dart';
import 'package:cmp/pages/playlist/tabs/SubscriberScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistDetailScreen extends StatefulWidget {
  Playlist _playlist;
  Role _userRole;

  PlaylistDetailScreen(Map pMap) {
    this._playlist = pMap['playlist'];
    this._userRole = pMap['user_role'];
  }

  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: (this.widget._playlist.creator.userID == Controller().authentificator.user.userID ? 3 : 2),
      child: Scaffold(
        backgroundColor: Controller().theming.background,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Controller().theming.fontSecondary,
          ),
          backgroundColor: Controller().theming.primary,
          bottom: TabBar(
            labelColor: Controller().theming.fontSecondary,
            indicator: BoxDecoration(),
            tabs: (this.widget._playlist.creator.userID == Controller().authentificator.user.userID
                ? [
                    Tab(
                      text: "Details",
                      icon: Icon(
                        Icons.info,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                    Tab(
                      text: "Teilnehmer",
                      icon: Icon(
                        Icons.people,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                    Tab(
                      text: "Anfragen",
                      icon: Icon(
                        Icons.person_add,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                  ]
                : [
                    Tab(
                      text: "Details",
                      icon: Icon(
                        Icons.info,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                    Tab(
                      text: "Teilnehmer",
                      icon: Icon(
                        Icons.people,
                        color: Controller().theming.fontSecondary,
                      ),
                    ),
                  ]),
          ),
          title: Text(
            "Informationen zu " + this.widget._playlist.name,
            style: TextStyle(
              color: Controller().theming.fontSecondary,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 10,
                color: Controller().theming.accent,
              ),
            ),
          ),
          child: (this.widget._playlist.creator.userID == Controller().authentificator.user.userID
              ? TabBarView(
                  children: <Widget>[
                    DetailScreen(this.widget._playlist),
                    SubscriberScreen(this.widget._playlist, this.widget._userRole),
                    RequestScreen(this.widget._playlist),
                  ],
                )
              : TabBarView(
                  children: <Widget>[
                    DetailScreen(this.widget._playlist),
                    SubscriberScreen(this.widget._playlist, this.widget._userRole),
                  ],
                )),
        ),
      ),
    );
  }
}
