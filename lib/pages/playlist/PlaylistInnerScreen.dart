import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/YouTubePlayer.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistInnerScreen extends StatefulWidget {
  Playlist _playlist;

  PlaylistInnerScreen(this._playlist);

  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  YoutubePlayerController _controller;
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHideAnnotation: true,
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
          centerTitle: true,
          elevation: 0,
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
            ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      "Liedname",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "irgendein Pupssubtitle",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SoundBar(),
      ),
    );
  }
}

class SoundBar extends StatefulWidget {
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  bool _isPlaying;
  double _percentage;
  StreamSubscription _durationStream;

  void initState() {
    super.initState();
    this._percentage = 0;

    AudioPlayerState state = Controller().soundPlayer.state;
    if (state == AudioPlayerState.PLAYING) {
      this._isPlaying = true;
    } else {
      this._isPlaying = false;
    }
    Controller().soundPlayer.duration.then((int duration) {
      this._durationStream = Controller().soundPlayer.durationStream.listen((Duration p) {
        setState(() {
          this._percentage = (p.inMilliseconds / duration);
        });
      });
    });
  }

  Widget build(BuildContext context) {
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
                    image: NetworkImage('https://i1.rgstatic.net/ii/profile.image/389167491108866-1469796168262_Q512/Andreas_Judt.jpg'),
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
                      'Apache 207',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Warum tust du dir das an?',
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
                onPressed: () {
                  //YouTubeSoundPlayer();
                  if (this._isPlaying) {
                    setState(() {
                      Controller().soundPlayer.pause();
                      this._isPlaying = false;
                    });
                  } else {
                    setState(() {
                      Controller().soundPlayer.play();
                      this._isPlaying = true;
                    });
                  }
                },
                icon: Icon(
                  (this._isPlaying ? Icons.pause : Icons.play_arrow),
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
    super.dispose();
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
