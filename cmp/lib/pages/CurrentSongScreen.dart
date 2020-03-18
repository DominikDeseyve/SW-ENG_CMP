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
        hideControls: false,
        forceHideAnnotation: true,
        hideThumbnail: false,
      ),
    );

    Controller().soundManager.addListener(this._updateScreen);
    this._position = new Duration();
    this._init();
  }

  void _init() async {
    this._duration = Duration(milliseconds: await Controller().soundManager.duration);
    this._position = Duration(milliseconds: await Controller().soundManager.position);
    setState(() {});
    this._durationStream = Controller().soundManager.durationStream.listen((Duration p) {
      setState(() {
        this._position = p;
      });
    });
  }

  void _updateScreen() {
    print("## CurrentSongScreen._updateScreen");
    print(Controller().soundManager.state);
    setState(() {});
  }

  void _togglePlay() async {
    if (Controller().soundManager.state == SoundState.PLAYING) {
      this._youtubePlayerController.pause();
      await Controller().soundManager.pause();
    } else {
      int position = await Controller().soundManager.position;
      this._youtubePlayerController.seekTo(Duration(milliseconds: position + 450), allowSeekAhead: true);
      await Controller().soundManager.play();
      this._youtubePlayerController.play();
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
    if (this._duration == null || Controller().soundManager.state == null || Controller().soundManager.currentSong == null) return Container();

    return Scaffold(
      backgroundColor: Controller().theming.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          elevation: 0,
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
            iconSize: 34,
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
                  onTap: () {
                    print(_youtubePlayerController.value.isPlaying);
                  },
                  onDoubleTap: () {
                    this._youtubePlayerController.toggleFullScreenMode();
                  },
                  child: YoutubePlayer(
                    controller: _youtubePlayerController,
                    showVideoProgressIndicator: false,
                    topActions: <Widget>[],
                    bottomActions: <Widget>[
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          this._youtubePlayerController.toggleFullScreenMode();
                        },
                        icon: Icon(Icons.fullscreen),
                        color: Colors.white,
                        iconSize: 35,
                      )
                    ],
                    onReady: () {
                      print('Player is ready.');
                      this._youtubePlayerController.seekTo(Duration(milliseconds: this._position.inMilliseconds + 450), allowSeekAhead: true);
                    },
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(
                    Controller().soundManager.currentSong.imageURL,
                    height: 225,
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
                      onPressed: () async {
                        await Controller().soundManager.deleteQueue();
                        Navigator.of(context).pop();
                      },
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
                          (Controller().soundManager.state == SoundState.PLAYING ? Icons.pause : Icons.play_arrow),
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
    this._youtubePlayerController.dispose();
    super.dispose();
  }
}
