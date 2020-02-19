import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/widgets/Queue.dart';
import 'package:cmp/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistInnerScreen extends StatefulWidget {
  final Playlist _playlist;
  PlaylistInnerScreen(this._playlist);
  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  Queue _queue;
  ScrollController _scrollController;

  void initState() {
    super.initState();
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

  void _loadMoreSongs(QuerySnapshot pQuery) {
    print("SONGS LOADED: " + pQuery.documentChanges.length.toString());
    setState(() {});
  }

  void _buildQueue() {
    setState(() {});
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
          actions: (this.widget._playlist.creator.userID == Controller().authentificator.user.userID
              ? <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/playlist/edit', arguments: this.widget._playlist);
                    },
                    icon: Icon(
                      Icons.edit,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertClass("Playlist löschen!", "Wollen Sie die Playlist wirklich löschen?"),
                        barrierDismissible: false,
                      );
                    },
                    icon: Icon(
                      Icons.block,
                    ),
                  ),
                ]
              : <Widget>[
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertClass("Playlist verlassen!", "Wollen Sie die Playlist wirklich verlassen?"),
                        barrierDismissible: false,
                      );
                    },
                    icon: Icon(
                      Icons.block,
                    ),
                  ),
                ]),
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
                  Navigator.of(context).pushNamed('/playlist/detailview', arguments: this.widget._playlist);
                },
                child: Container(
                  height: (MediaQuery.of(context).size.height * 0.21) - 30,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.15,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (this.widget._playlist.imageURL != null ? NetworkImage(this.widget._playlist.imageURL) : AssetImage('assets/images/playlist.jpg')),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          (Controller().authentificator.user.role.role == ROLE.MASTER || Controller().authentificator.user.role.role == ROLE.ADMIN
              ? Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 28,
                        margin: EdgeInsets.fromLTRB(90, 15, 90, 0),
                        child: OutlineButton(
                          onPressed: () {
                            Controller().soundPlayer.setQueue(this._queue);
                          },
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Icon(
                                  Icons.playlist_add,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Play",
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 28,
                  margin: EdgeInsets.fromLTRB(90, 15, 90, 0),
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/playlist/add');
                    },
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.playlist_add,
                            size: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Song hinzufügen",
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 35, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Warteschlange",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
                Divider(
                  thickness: 1.5,
                  color: Color(0xFF253A4B),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: this._queue.songs.length,
            itemBuilder: (BuildContext context, int index) {
              return SongItem(this._queue.songs[index], this.widget._playlist);
            },
          ),
        ],
      ),

      /*bottomNavigationBar: BottomAppBar(
        child: SoundBar(),
      ),*/
    );
  }

  void dispose() {
    this._queue.cancel();
    //Controller().soundPlayer.queue.removeListener(this._buildQueue);
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
  Widget build(BuildContext context) {
    String _currentSongID = '-1';
    if (Controller().soundPlayer.currentSong != null) {
      _currentSongID = Controller().soundPlayer.currentSong.songID;
    }
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: (_currentSongID == this.widget._song.songID ? Colors.redAccent.withOpacity(0.2) : Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15),
            Avatar(
              this.widget._song,
            ),
            SizedBox(width: 10),
            Column(
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
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
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

class AlertClass extends StatelessWidget {
  String title;
  String subtitle;

  AlertClass(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.subtitle),
      actions: <Widget>[
        FlatButton(
          child: Text('Ja'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Nein'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
