import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/HTTP.dart';
import 'package:cmp/models/Queue.dart';
import 'package:cmp/models/song.dart';

class SoundPlayer {
  AudioPlayer _audioPlayer;
  Queue _queue;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    //this._loadSong();
  }

  void _loadSong(Song pSong) {
    this._audioPlayer.setVolume(1);
    this._audioPlayer.setUrl(pSong.youTubeURL);
    //String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    //url = "https://www.youtube.com/embed/Z0kuMR9nW0E";
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

  void startQueue() {
    this._loadSong(this._queue.currentSong);
    this.play();
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set queue(Queue pQueue) {
    this._queue = pQueue;
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
