import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/models/song.dart';

class Player {
  AudioPlayer _audioPlayer;
  Song _song;

  Player() {
    this._audioPlayer = new AudioPlayer();
    this._audioPlayer.setVolume(1);
    AudioPlayer.logEnabled = false;
  }

  Future<void> initSong(Song pSong) async {
    this._song = pSong;
    if (pSong.soundURL == null) {
      print("ERROR: Sound Url not laoded");
    }
    await this._audioPlayer.setUrl(pSong.soundURL);
  }

  Future<int> fetchDuration() async {
    if (this._song.soundURL.isEmpty) {
      return 0;
    } else {
      return await this._audioPlayer.getDuration();
    }
  }

  //***************************************************//
  //*********   SOUND METHODS
  //***************************************************//
  Future<void> play() async {
    print("PLAYING: " + this._song.titel);
    await this._audioPlayer.resume();
  }

  Future<void> pause() async {
    this._audioPlayer.pause();
  }

  Future<void> seek(Duration pPosition) async {
    await this._audioPlayer.seek(pPosition);
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set volume(double pVolume) {
    this._audioPlayer.setVolume(pVolume);
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Song get song {
    return this._song;
  }

  bool get hasSong {
    return (this._song != null);
  }

  AudioPlayerState get state {
    return this._audioPlayer.state;
  }

  Stream<Duration> get durationStream {
    //print(this.song.duration);
    return this._audioPlayer.onAudioPositionChanged;
  }

  Stream<void> get onPlayerCompletion {
    return this._audioPlayer.onPlayerCompletion;
  }

  Future<int> getAudioDuration() async {
    return await this._audioPlayer.getDuration();
  }
}
