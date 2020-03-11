import 'dart:async';
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

    this._durationStream = Controller().soundManager.percentage.listen(this._percentageListener);
  }

  void _percentageListener(double pPercentage) {
    if (!mounted) return;
    setState(() {
      this._percentage = pPercentage;
    });
  }

  void _togglePlay() async {
    if (Controller().soundManager.state == SoundState.PLAYING) {
      Controller().soundManager.pause();
    } else {
      Controller().soundManager.play();
    }
  }

  void _initSoundbar() {
    print("CHANGE NOTIFIER IN INIT SOUNDBAR");
    this._durationStream.cancel();
    this._durationStream = Controller().soundManager.percentage.listen(this._percentageListener);
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
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    SongAvatar(
                      Controller().soundManager.currentSong,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: (Controller().soundManager.currentSong.platform == 'YOUTUBE'
                            ? Image.asset(
                                'assets/icons/youtube.png',
                                width: 15,
                              )
                            : Image.asset(
                                'assets/icons/soundcloud.png',
                                width: 15,
                              )),
                      ),
                    ),
                  ],
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                    (Controller().soundManager.state == SoundState.PLAYING ? Icons.pause : Icons.play_arrow),
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
    print("dispose sound bar");
    this._durationStream.cancel();

    Controller().soundManager.removeListener(this._initSoundbar);
    super.dispose();
  }
}
