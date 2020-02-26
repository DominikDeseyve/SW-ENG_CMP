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
      backgroundColor: Controller().theming.background,
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
              height: 7,
              color: Controller().theming.accent,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: this.getPlaylists,
        child: ListView(
          children: <Widget>[
            //erstellte Playlists
            SizedBox(height: 5),
            (this._createdPlaylist.length > 0
                ? Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Controller().theming.accent,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                width: 20,
                                height: 15,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Erstellte Playlists",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  color: Controller().theming.fontPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Die ganzen Events
                      Container(
                        color: Colors.grey.withOpacity(0.05),
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
            SizedBox(height: 10),
            (this._joinedPlaylist.length > 0
                ? Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Controller().theming.accent,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                width: 20,
                                height: 15,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Beigetretene Playlists",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  color: Controller().theming.fontPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Die ganzen Events
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.05),
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
        margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Column(
          children: <Widget>[
            PlaylistAvatar(
              this._playlist,
              width: 100,
            ),
            SizedBox(height: 7),
            Expanded(
              child: Container(
                width: 120,
                child: Text(
                  this._playlist.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
