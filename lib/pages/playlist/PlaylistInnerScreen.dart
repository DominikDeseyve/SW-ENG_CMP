import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlaylistInnerScreen extends StatefulWidget {
  Playlist _playlist;

  PlaylistInnerScreen(this._playlist);

  _PlaylistInnerScreenState createState() => _PlaylistInnerScreenState();
}

class _PlaylistInnerScreenState extends State<PlaylistInnerScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xFF253A4B),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.block,
              ),
            ),
          ],
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
                    painter: CurvePainter(Color(0xFF253A4B), (0.14 / 0.21), 1, (0.14 / 0.21)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/playlist/detailview', arguments: this.widget._playlist);
                  },
                  child: Container(
                    height: (MediaQuery.of(context).size.height * 0.21) - 30,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment(0, -0.5),
                    child: Text(
                      this.widget._playlist.name,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
          print(this._percentage);
        });
        //print('Current position: ' + percentage.toString());
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
                    image: AssetImage('assets/images/playlist.jpg'),
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
                onPressed: () {},
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
