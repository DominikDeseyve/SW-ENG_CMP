import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/models/song.dart';

class SoundPlayer {
  AudioPlayer _audioPlayer;
  Song _currentSong;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    this._init();
  }

  void _init() {
    this._audioPlayer.setVolume(1);
    String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    this._audioPlayer.setUrl(url);
  }

  void play() async {
    this._audioPlayer.resume();
  }

  void pause() {
    this._audioPlayer.pause();
  }

  void skip() {
    this._audioPlayer.pause();
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set song(Song pSong) {
    this._currentSong = pSong;
    //this._audioPlayer.setUrl(pSong.soundURL);
  }
  //***************************************************//
  //*********   GETTER
  //***************************************************//

  AudioPlayerState get state {
    return this._audioPlayer.state;
  }

  Stream<Duration> get durationStream {
    return this._audioPlayer.onAudioPositionChanged;
  }

  Future<int> get duration {
    return this._audioPlayer.getDuration();
  }
}
