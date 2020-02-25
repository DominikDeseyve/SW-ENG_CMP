import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
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

    getPlaylists();
  }

  Future<void> getPlaylists() async {
    Controller().firebase.getCreatedPlaylist().then((pCreatedPlaylist) {
      if (!mounted) return;
      setState(() {
        this._createdPlaylist = pCreatedPlaylist;
      });
    });

    Controller().firebase.getJoinedPlaylist().then((pJoinedPlaylist) {
      if (!mounted) return;
      setState(() {
        this._joinedPlaylist = pJoinedPlaylist;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Connected Music Playlist",
                style: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 10,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: this.getPlaylists,
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
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.normal,
                                color: Controller().theming.fontPrimary,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Controller().theming.fontPrimary,
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
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                                color: Controller().theming.fontPrimary,
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              color: Controller().theming.fontPrimary,
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
        Navigator.of(context).pushNamed('/playlist', arguments: this._playlist);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Column(
          children: <Widget>[
            PlaylistAvatar(
              this._playlist,
              width: 110,
            ),
            SizedBox(height: 7),
            Text(
              this._playlist.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                color: Controller().theming.fontPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
