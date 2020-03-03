import 'package:audioplayers/audioplayers.dart';

class Player {
  AudioPlayer _audioPlayer;

  Player() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    this._audioPlayer.setVolume(1);
  }

  void init(String pURL) async {
    this._audioPlayer.setUrl(pURL);
  }

  void play() async {
    this._audioPlayer.resume();
  }

  void pause() async {
    this._audioPlayer.pause();
  }
}
