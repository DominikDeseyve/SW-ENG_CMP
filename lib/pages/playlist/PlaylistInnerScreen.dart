import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Queue.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:cmp/widgets/Pagination.dart';
import 'package:cmp/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistInnerScreen extends StatefulWidget {
  final Playlist _playlist;
  PlaylistInnerScreen(this._playlist);
  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  PaginationStream _pagination;
  Queue _queue;

  void initState() {
    super.initState();

    this._queue = new Queue();

    this._pagination = new PaginationStream();
    this._pagination.setCallback(this._loadMoreItems);
    this._pagination.stream = Controller().firebase.getPlaylistQueue(this.widget._playlist, this._pagination);
    this._pagination.listen();
  }

  void _loadMoreItems(QuerySnapshot pQuery) async {
    setState(() {
      pQuery.documents.forEach((DocumentSnapshot pSong) {
        Song song = Song.fromFirebase(pSong);
        int index = this._queue.songs.indexWhere((item) => item.songID == song.songID);
        if (index > -1) {
          this._queue.songs.removeAt(index);
          this._queue.songs.insert(index, song);
        } else {
          this._queue.songs.add(song);
        }
      });
      Controller().soundPlayer.queue = this._queue;
    });
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
          centerTitle: true,
          elevation: 0,
          actions: (this.widget._playlist.creator.userID == Controller().authentificator.user.userID
              ? <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.block,
                    ),
                  ),
                ]
              : <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.block,
                    ),
                  ),
                ]),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [
              Colors.grey[400],
              Colors.white,
            ],
          ),
        ),
        child: ListView(
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
                      top: 2,
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
                              Controller().soundPlayer.startQueue();
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
                      onPressed: () {},
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
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: this._queue.songs.length,
              itemBuilder: (BuildContext context, int index) {
                return SongItem(this._queue.songs[index], this.widget._playlist);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SoundBar(),
      ),
    );
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
    return Container(
      color: (Controller().soundPlayer.queue.currentSong.songID == this.widget._song.songID ? Colors.redAccent.withOpacity(0.2) : Colors.transparent),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        onTap: () {},
        leading: Avatar(
          this.widget._song,
        ),
        title: Text(
          this.widget._song.artist,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          this.widget._song.titel,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () {
                Controller().firebase.thumbUpSong(this.widget._playlist, this.widget._song);
              },
            ),
            IconButton(
              icon: Icon(Icons.thumb_down),
              onPressed: () {
                Controller().firebase.thumbDownSong(this.widget._playlist, this.widget._song);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SoundBar extends StatefulWidget {
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  double _percentage;
  StreamSubscription _durationStream;

  void initState() {
    super.initState();
    Controller().soundPlayer.addListener(this._initSoundbar);
    this._percentage = 0;
  }

  void _togglePlay() async {
    if (Controller().soundPlayer.state == AudioPlayerState.PLAYING) {
      Controller().soundPlayer.pause();
      this._durationStream.pause();
    } else {
      Controller().soundPlayer.play();

      int duration = await Controller().soundPlayer.duration;
      this._durationStream = Controller().soundPlayer.durationStream.listen((Duration p) {
        setState(() {
          this._percentage = (p.inMilliseconds / duration);
        });
      });
    }
  }

  void _initSoundbar() {
    print("CHANGE NOTIFIER IN INIT SOUNDBAR");
    setState(() {
      var t = 123;
    });
  }

  Widget build(BuildContext context) {
    if (Controller().soundPlayer.queue.currentSong == null) return SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * this._percentage,
          height: 5,
          color: Colors.redAccent,
        ),
        Container(
          color: Color(0xFF253A4B),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                child: InkWell(
                  child: Image(
                    width: 45,
                    height: 45,
                    image: NetworkImage(Controller().soundPlayer.queue.currentSong.imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      Controller().soundPlayer.queue.currentSong.artist,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      Controller().soundPlayer.queue.currentSong.titel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: this._togglePlay,
                icon: Icon(
                  (Controller().soundPlayer.state == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Controller().soundPlayer.skip();
                },
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void dispose() {
    this._durationStream.cancel();
    Controller().soundPlayer.removeListener(this._initSoundbar);
    super.dispose();
  }
}
