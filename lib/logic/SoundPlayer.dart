import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  AudioPlayer _audioPlayer;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
  }

  void play() async {
    this._audioPlayer.setVolume(1);
    String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    int result = await this._audioPlayer.setUrl(url);
    if (result == 1) {
      this._audioPlayer.resume();
    }
  }

  void pause() {
    this._audioPlayer.pause();
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
