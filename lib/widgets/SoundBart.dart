import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/avatar.dart';
import 'package:flutter/material.dart';

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
    }
  }

  void _initSoundbar() {
    print("CHANGE NOTIFIER IN INIT SOUNDBAR");
    if (Controller().soundPlayer.state == AudioPlayerState.PLAYING) {
      this._durationStream = Controller().soundPlayer.durationStream.listen((Duration p) {
        Controller().soundPlayer.duration.then((int duration) {
          setState(() {
            this._percentage = (p.inMilliseconds / duration);
          });
        });
      });
    } else {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    if (Controller().soundPlayer.currentSong == null) return SizedBox.shrink();
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        Navigator.of(context).pushNamed('/song/current');
      },
      child: Column(
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
            height: 60,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Avatar(
                  Controller().soundPlayer.currentSong,
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Controller().soundPlayer.currentSong.artist,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        Controller().soundPlayer.currentSong.titel,
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
                    size: 26,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Controller().soundPlayer.nextSong();
                  },
                  icon: Icon(
                    Icons.skip_next,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    this._durationStream.cancel();

    Controller().soundPlayer.removeListener(this._initSoundbar);
    super.dispose();
  }
}
