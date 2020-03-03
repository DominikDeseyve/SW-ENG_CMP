import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/widgets/SongAvatar.dart';
import 'package:flutter/material.dart';

class SoundBar extends StatefulWidget {
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  double _percentage;
  StreamSubscription _durationStream;

  void initState() {
    super.initState();
    Controller().soundManager.addListener(this._initSoundbar);
    this._percentage = 0;

    this._durationStream = Controller().soundManager.durationStream.listen((Duration p) {
      Controller().soundManager.duration.then((int duration) {
        if (!mounted) return;
        setState(() {
          this._percentage = (p.inMilliseconds / duration);
        });
      });
    });
  }

  void _togglePlay() async {
    if (Controller().soundManager.state == AudioPlayerState.PLAYING) {
      Controller().soundManager.pause();
    } else {
      Controller().soundManager.play();
    }
  }

  void _initSoundbar() {
    print("CHANGE NOTIFIER IN INIT SOUNDBAR");
    setState(() {});
  }

  Widget build(BuildContext context) {
    if (Controller().soundManager.currentSong == null) return SizedBox.shrink();
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
                SongAvatar(
                  Controller().soundManager.currentSong,
                  width: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          Controller().soundManager.currentSong.artist + ' aus  ' + Controller().soundManager.playlist.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          Controller().soundManager.currentSong.titel,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: this._togglePlay,
                  icon: Icon(
                    (Controller().soundManager.state == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Controller().soundManager.nextSong();
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

    Controller().soundManager.removeListener(this._initSoundbar);
    super.dispose();
  }
}