import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
import 'package:cmp/widgets/SongAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class PlaylistInnerScreen extends StatefulWidget {
  final Playlist _playlist;
  PlaylistInnerScreen(this._playlist);
  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  Role _userRole;
  Queue _queue;
  ScrollController _scrollController;

  void initState() {
    super.initState();

    this._userRole = new Role(ROLE.MEMBER);
    this._fetchRole();

    Controller().soundPlayer.addListener(this._buildQueue);

    this._queue = new Queue(this.widget._playlist);
    this._queue.setCallback(this._loadMoreSongs);

    this._scrollController = new ScrollController();
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("END OF SCREEN --> LOAD MORE");
        this._queue.loadMore();
      }
    });
  }

  void _fetchRole() {
    Controller().firebase.getPlaylistUserRole(this.widget._playlist, Controller().authentificator.user).then((Role pRole) {
      setState(() {
        this._userRole = pRole;
      });
    });
  }

  void _loadMoreSongs(QuerySnapshot pQuery) {
    print("SONGS LOADED: " + pQuery.documentChanges.length.toString());
    if (!mounted) return;
    setState(() {});
  }

  void _buildQueue() {
    if (!mounted) return;
    setState(() {});
  }

  void _showOptionAlert(String pTitle, String pSubtitle) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(pTitle),
        content: Text(pSubtitle),
        actions: <Widget>[
          FlatButton(
            child: Text('Ja'),
            onPressed: () async {
              User user = Controller().authentificator.user;
              String userID = Controller().authentificator.user.userID;

              if (this.widget._playlist.creator.userID == userID) {
                print("playlist löschen");
                await Controller().firebase.deletePlaylist(this.widget._playlist).then((_) {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                });
              } else {
                Controller().firebase.leavePlaylist(this.widget._playlist, user).then((_) {
                  print("playlist verlassen");
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                });
              }
            },
          ),
          FlatButton(
            child: Text('Nein'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            this.widget._playlist.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF253A4B),
          actions: <Widget>[
            (this._userRole.role == ROLE.ADMIN
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/playlist/edit', arguments: this.widget._playlist).then((value) {
                        setState(() {});
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                    ),
                  )
                : SizedBox.shrink()),
            PopupMenuButton(
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                (this.widget._playlist.creator.userID == Controller().authentificator.user.userID
                    ? PopupMenuItem(
                        value: 1,
                        child: Container(
                          width: double.infinity,
                          child: GestureDetector(
                            child: Text(
                              "Playlist löschen",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              _showOptionAlert("Playlist löschen!", "Wollen Sie die Playlist wirklich löschen?");
                            },
                          ),
                        ),
                      )
                    : PopupMenuItem(
                        value: 1,
                        child: GestureDetector(
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Playlist verlassen",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            _showOptionAlert("Playlist verlassen!", "Wollen Sie die Playlist wirklich verlassen?");
                          },
                        ),
                      )),
                PopupMenuItem(
                  value: 1,
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Code ansehen",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        controller: this._scrollController,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.225,
                child: CustomPaint(
                  painter: CurvePainter(Colors.redAccent, (0.155 / 0.225), 1, (0.155 / 0.225)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.21,
                child: CustomPaint(
                  painter: CurvePainter(Color(0xFF253A4B), (0.145 / 0.21), 1, (0.145 / 0.21)),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/playlist/detailview', arguments: this.widget._playlist).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  height: (MediaQuery.of(context).size.height * 0.25) - 30,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: PlaylistAvatar(
                    this.widget._playlist,
                    width: 100,
                  ),
                ),
              ),
              (this._userRole.role == ROLE.MASTER
                  ? Positioned(
                      bottom: 5,
                      left: 50,
                      child: Container(
                        child: RawMaterialButton(
                          onPressed: () {
                            Controller().theming.showSnackbar(context, 'Die Playlist "' + this.widget._playlist.name + '" wird abgespielt...');
                            Controller().soundPlayer.setQueue(this._queue, this.widget._playlist);
                          },
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                          shape: new CircleBorder(),
                          fillColor: Colors.redAccent,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  : SizedBox.shrink()),
              Positioned(
                bottom: 5,
                right: 50,
                child: Container(
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/playlist/add', arguments: this.widget._playlist);
                    },
                    child: Icon(
                      Icons.playlist_add,
                      size: 30,
                      color: Colors.white,
                    ),
                    shape: new CircleBorder(),
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ),
              )
            ],
          ),
          (this._queue.currentSong != null
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 35, 30, 0),
                        child: Text(
                          "Gerade läuft",
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Color(0xFF253A4B),
                      ),
                      CurrentSongItem(this._queue.currentSong),
                    ],
                  ),
                )
              : SizedBox.shrink()),
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
                      color: Colors.redAccent,
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
                    "Warteschlange",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.normal,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          (this._queue.length > 0
              ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._queue.songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SongItem(this._queue.songs[index], this.widget._playlist);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 35, top: 15),
                  child: Text(
                    'Keine Songs vorhanden',
                    style: TextStyle(
                      fontSize: 16,
                      color: Controller().theming.fontPrimary,
                    ),
                  ),
                )),
        ],
      ),

      /*bottomNavigationBar: BottomAppBar(
        child: SoundBar(),
      ),*/
    );
  }

  void dispose() {
    this._queue.cancel();
    Controller().soundPlayer.removeListener(this._buildQueue);
    super.dispose();
  }
}

class SongItem extends StatefulWidget {
  final Song _song;
  final Playlist _playlist;
  SongItem(this._song, this._playlist);
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  void initState() {
    super.initState();
  }

  void _showOptionDialog() {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(
              height: 1,
            ),
            FlatButton(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              onPressed: () async {
                Controller().firebase.deleteSong(this.widget._playlist, this.widget._song);
                Navigator.of(dialogContext).pop(null);
              },
              child: Container(
                width: MediaQuery.of(dialogContext).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5, right: 0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            'Song entfernen',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {
        if (this.widget._song.creator.userID == Controller().authentificator.user.userID) {
          this._showOptionDialog();
        }
      },
      child: Container(
        color: Colors.grey.withOpacity(0.05),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15),
            SongAvatar(
              this.widget._song,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.widget._song.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    this.widget._song.titel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.thumb_up,
                        color: (this.widget._song.isUpvoting ? Colors.redAccent : Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          Controller().authentificator.user.thumbUpSong(this.widget._song);
                          Controller().firebase.thumbUpSong(this.widget._playlist, this.widget._song);
                        });
                      },
                    ),
                    Text(this.widget._song.upvoteCount.toString()),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.thumb_down,
                        color: (this.widget._song.isDownvoting ? Colors.redAccent : Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          Controller().authentificator.user.thumbDownSong(this.widget._song);
                          Controller().firebase.thumbDownSong(this.widget._playlist, this.widget._song);
                        });
                      },
                    ),
                    Text(this.widget._song.downvoteCount.toString()),
                  ],
                ),
              ],
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}

class CurrentSongItem extends StatelessWidget {
  final Song _song;
  CurrentSongItem(this._song);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15),
            SongAvatar(
              this._song,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this._song.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    this._song.titel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
      ),
    );
  }
}
