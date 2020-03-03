import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/PlaylistAvatar.dart';
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
      initialVideoId: Controller().soundManager.currentSong.youTubeID,
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: false,
        disableDragSeek: true,
        mute: true,
        autoPlay: true,
        hideControls: true,
        forceHideAnnotation: true,
      ),
    );

    Controller().soundManager.addListener(this._updateScreen);
    this._position = new Duration();
    this._duration = new Duration(seconds: 1);

    Controller().soundManager.duration.then((int duration) {
      setState(() {
        this._duration = new Duration(milliseconds: duration);
      });
    });
    this._durationStream = Controller().soundManager.durationStream.listen((Duration p) {
      setState(() {
        this._position = p;
      });
    });
  }

  void _updateScreen() {
    setState(() {
      AudioPlayerState state = Controller().soundManager.state;
      switch (state) {
        case AudioPlayerState.PLAYING:
          this._youtubePlayerController.play();
          break;
        case AudioPlayerState.PAUSED:
          this._youtubePlayerController.pause();
          break;
        default:
      }
    });
  }

  void _togglePlay() async {
    if (Controller().soundManager.state == AudioPlayerState.PLAYING) {
      Controller().soundManager.pause();
    } else {
      Controller().soundManager.play();
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
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color(0xFF253A4B),
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Wiedergabe aus",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.tune),
                  iconSize: 20,
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              height: 49,
              color: Color(0xFF253A4B),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PlaylistAvatar(Controller().soundManager.playlist, width: 45),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Text(
                        Controller().soundManager.playlist.creator.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        Controller().soundManager.playlist.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 5,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView(
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    Slider(
                      value: this._position.inSeconds.toDouble(),
                      min: 0,
                      max: this._duration.inSeconds.toDouble(),
                      divisions: this._duration.inSeconds,
                      activeColor: Colors.redAccent,
                      label: this._formatDuration(this._position),
                      inactiveColor: Colors.grey,
                      onChanged: (double pNewSeconds) {
                        setState(() {
                          _position = new Duration(seconds: pNewSeconds.toInt());
                          Controller().soundManager.seek(_position);
                          this._youtubePlayerController.seekTo(this._position);
                        });
                      },
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        Text(this._formatDuration(this._position)),
                        Spacer(),
                        Text(this._formatDuration(this._duration)),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Controller().soundManager.currentSong.artist.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      Controller().soundManager.currentSong.titel,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          color: Colors.black.withOpacity(0.75),
                          iconSize: 35,
                          icon: Icon(Icons.stop),
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: new BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: new IconButton(
                            iconSize: 40,
                            icon: new Icon(
                              (Controller().soundManager.state == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                              color: Colors.white,
                            ),
                            onPressed: this._togglePlay,
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          color: Colors.black.withOpacity(0.75),
                          iconSize: 35,
                          icon: Icon(
                            Icons.skip_next,
                          ),
                          onPressed: () {
                            this._position = new Duration();
                            Controller().soundManager.nextSong();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: -30,
            bottom: -10,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 20, 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shuffle,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: -30,
            bottom: -10,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 30, 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    Controller().soundManager.removeListener(this._updateScreen);
    this._durationStream.cancel();
    super.dispose();
  }
}
