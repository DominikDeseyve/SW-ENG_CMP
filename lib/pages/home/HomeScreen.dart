import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Playlist> _popularPlaylist = [];

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
    Controller().firebase.getPopularPlaylist().then((QuerySnapshot pQuery) {
      if (!mounted) return;
      setState(() {
        this._popularPlaylist.clear();
        pQuery.documents.forEach((DocumentSnapshot pSnap) {
          this._popularPlaylist.add(Playlist.fromFirebase(pSnap));
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Controller().theming.primary,
              centerTitle: true,
              elevation: 0,
              title: Text(
                Controller().translater.language.appName,
                style: TextStyle(
                  color: Controller().theming.fontSecondary,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.storage),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/playlist/category', arguments: 'ALL');
                  },
                ),
              ],
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
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Controller().theming.tertiary.withOpacity(0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Herzlich Willkommen ' + Controller().authentificator.user.username,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.mood,
                    size: 25,
                    color: Controller().theming.fontPrimary,
                  ),
                ],
              ),
            ),
            //erstellte Playlists
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
                                Controller().translater.language.joinedPlaylists,
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
                        color: Controller().theming.tertiary.withOpacity(0.1),
                        height: 145,
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
                        color: Controller().theming.tertiary.withOpacity(0.1),
                        width: MediaQuery.of(context).size.width,
                        height: 145,
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

            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/playlist/category', arguments: 'POPULAR');
                  },
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
                          "Aktuell beliebt",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Controller().theming.fontPrimary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                            color: Controller().theming.fontPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Die ganzen Events
                Container(
                  color: Controller().theming.tertiary.withOpacity(0.1),
                  width: MediaQuery.of(context).size.width,
                  height: 145,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(right: 20),
                    shrinkWrap: true,
                    itemCount: this._popularPlaylist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PlaylistItem(this._popularPlaylist.elementAt(index));
                    },
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

class PlaylistItem extends StatelessWidget {
  final Playlist _playlist;
  PlaylistItem(this._playlist);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/playlist', arguments: this._playlist.playlistID);
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
