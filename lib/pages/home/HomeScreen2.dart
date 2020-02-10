import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Playlist> _createdPlaylist = [];
  List<Playlist> _joinedPlaylist = [];

  void initState() {
    super.initState();
    Controller().firebase.getCreatedPlaylist().then((pCreatedPlaylist) {
      setState(() {
        this._createdPlaylist = pCreatedPlaylist;
      });
    });

    Controller().firebase.getJoinedPlaylist().then((pJoinedPlaylist) {
      setState(() {
        this._joinedPlaylist = pJoinedPlaylist;
      });
    });
  }

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
                (this._createdPlaylist.length > 0
                    ? Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Erstellte Playlists",
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
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
                            width: MediaQuery.of(context).size.width,
                            height: 160,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 20),
                              shrinkWrap: true,
                              itemCount: this._createdPlaylist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PlaylistItem(this._createdPlaylist.elementAt(index));
                              },
                            ),
                          ),
                        ],
                      )
                    : Container()),
                //beigetretene Playlists
                (this._joinedPlaylist.length > 0
                    ? Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Beigetretene Playlists",
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
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
                            width: MediaQuery.of(context).size.width,
                            height: 160,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 20),
                              shrinkWrap: true,
                              itemCount: this._joinedPlaylist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PlaylistItem(this._joinedPlaylist.elementAt(index));
                              },
                            ),
                          ),
                        ],
                      )
                    : Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  PlaylistItem(this._playlist);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.of(context).pushNamed('/profile', arguments: this._tinyUser.uid);
      },
      child: Container(
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
                  image: NetworkImage(this._playlist.imageURL),
                ),
              ),
            ),
            Text(
              this._playlist.name,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
            )
          ],
        ),
      ),
    );
  }
}
