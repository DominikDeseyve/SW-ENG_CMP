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
      initialVideoId: Controller().soundManager.currentSong.platformID,
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
    Controller().soundManager.duration.then((int pDuration) {
      this._duration = new Duration(milliseconds: pDuration);
      this._durationStream = Controller().soundManager.durationStream.listen((Duration p) {
        setState(() {
          this._position = p;
        });
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
    if (this._duration == null) return Container();
    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/playlist', arguments: Controller().soundManager.playlist.playlistID);
              },
              child: Container(
                padding: const EdgeInsets.all(0),
                height: 55,
                color: Color(0xFF253A4B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PlaylistAvatar(Controller().soundManager.playlist, width: 45),
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Controller().soundManager.playlist.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
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
            Controller().translater.language.getLanguagePack("played_from"),
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
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          (Controller().soundManager.currentSong.platform == 'YOUTUBE'
              ? GestureDetector(
                  onDoubleTap: () {
                    this._youtubePlayerController.toggleFullScreenMode();
                  },
                  child: YoutubePlayer(
                    controller: _youtubePlayerController,
                    showVideoProgressIndicator: true,
                    topActions: <Widget>[],
                    onReady: () {
                      print('Player is ready.');
                      this._youtubePlayerController.seekTo(this._position);
                      this._youtubePlayerController.play();
                    },
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(25),
                  child: Image.network(
                    Controller().soundManager.currentSong.imageURL,
                    height: 175,
                    fit: BoxFit.contain,
                  ),
                )),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                    Text(
                      this._formatDuration(this._position),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      this._formatDuration(this._duration),
                      style: TextStyle(
                        color: Controller().theming.fontPrimary,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  Controller().soundManager.currentSong.artist.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Controller().theming.fontPrimary.withOpacity(0.7),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Controller().soundManager.currentSong.titel,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.black.withOpacity(0.75),
                      iconSize: 35,
                      icon: Icon(
                        Icons.stop,
                        color: Controller().theming.fontPrimary,
                      ),
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
                        color: Controller().theming.fontPrimary,
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
    );
  }

  void dispose() {
    Controller().soundManager.removeListener(this._updateScreen);
    this._durationStream.cancel();
    super.dispose();
  }
}
