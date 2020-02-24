import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CurrentSongScreen extends StatefulWidget {
  _CurrentSongScreenState createState() => _CurrentSongScreenState();
}

class _CurrentSongScreenState extends State<CurrentSongScreen> {
  YoutubePlayerController _youtubePlayerController;
  Duration _position;
  Duration _duration;
  StreamSubscription _durationStream;

  void initState() {
    super.initState();
    this._youtubePlayerController = YoutubePlayerController(
      initialVideoId: Controller().soundPlayer.currentSong.youTubeID,
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: false,
        disableDragSeek: true,
        mute: true,
        autoPlay: true,
        hideControls: true,
        forceHideAnnotation: true,
      ),
    );

    Controller().soundPlayer.addListener(this._updateScreen);
    this._position = new Duration();
    this._duration = new Duration(seconds: 1);

    Controller().soundPlayer.duration.then((int duration) {
      setState(() {
        this._duration = new Duration(milliseconds: duration);
      });
    });
    this._durationStream = Controller().soundPlayer.durationStream.listen((Duration p) {
      setState(() {
        this._position = p;
      });
    });
  }

  void _updateScreen() {
    setState(() {});
  }

  void _togglePlay() async {
    if (Controller().soundPlayer.state == AudioPlayerState.PLAYING) {
      Controller().soundPlayer.pause();
    } else {
      Controller().soundPlayer.play();
    }
  }

  String _formatDuration(Duration pDuration) {
    int minutes = pDuration.inMinutes;
    int seconds = pDuration.inSeconds - (minutes * 60);
    String secondsString = seconds.toString();
    if (seconds < 10) {
      secondsString = '0' + secondsString;
    }
    return minutes.toString() + ':' + secondsString;
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
          GestureDetector(
            onDoubleTap: () {
              this._youtubePlayerController.toggleFullScreenMode();
            },
            child: YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
              topActions: <Widget>[],
              onReady: () {
                print('Player is ready.');
                this._youtubePlayerController.play();
                this._youtubePlayerController.seekTo(this._position, allowSeekAhead: false);
              },
            ),
          ),
          Slider(
            value: this._position.inSeconds.toDouble(),
            min: 0,
            max: this._duration.inSeconds.toDouble(),
            divisions: this._duration.inSeconds,
            activeColor: Colors.redAccent,
            label: this._formatDuration(this._position),
            inactiveColor: Colors.black,
            onChanged: (double pNewSeconds) {
              setState(() {
                _position = new Duration(seconds: pNewSeconds.toInt());
                Controller().soundPlayer.seek(_position);
                this._youtubePlayerController.seekTo(this._position);
              });
            },
          ),
          Row(
            children: <Widget>[
              Text(this._formatDuration(this._position)),
              Spacer(),
              Text(this._formatDuration(this._duration)),
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
                iconSize: 40,
                icon: Icon(
                  (Controller().soundPlayer.state == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                ),
                onPressed: this._togglePlay,
              ),
              IconButton(
                color: Colors.black,
                iconSize: 40,
                icon: Icon(
                  Icons.skip_next,
                ),
                onPressed: () {
                  this._position = new Duration();
                  Controller().soundPlayer.nextSong();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void dispose() {
    Controller().soundPlayer.removeListener(this._updateScreen);
    this._durationStream.cancel();
    super.dispose();
  }
}
