import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';

class CurrentSongScreen extends StatefulWidget {
  _CurrentSongScreenState createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  Duration _position;

  void initState() {
    super.initState();
    this._position = new Duration();
  }

  String _formatDuration(Duration pDuration) {
    int minutes = pDuration.inMinutes;
    int seconds = pDuration.inSeconds - (minutes * 60);
    return minutes.toString() + ':' + seconds.toString();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color(0xFF253A4B),
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Wiedergabe aus Playlist",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              height: 5,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        children: <Widget>[
          Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Image.network('https://images.genius.com/1437b72d059745e7dfaa8d109ff4d9fe.1000x1000x1.jpg'),
          ),
          Slider(
            value: this._position.inSeconds.toDouble(),
            min: 0,
            max: 352,
            divisions: 352,
            activeColor: Colors.redAccent,
            label: this._formatDuration(this._position),
            inactiveColor: Colors.black,
            onChanged: (double pNewSeconds) {
              setState(() {
                _position = new Duration(seconds: pNewSeconds.toInt());
                Controller().soundPlayer.seek(_position);
              });
            },
          ),
          Row(
            children: <Widget>[
              Text(this._formatDuration(this._position)),
              Spacer(),
              Text('3:55'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Controller().soundPlayer.currentSong.artist,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Text(
            Controller().soundPlayer.currentSong.titel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.pause,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
