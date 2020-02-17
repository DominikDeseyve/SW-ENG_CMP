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
    url = "https://www.youtube.com/embed/f-BzUepNeZw";
    url =
        'https://r3---sn-h0jeln7k.googlevideo.com/videoplayback?expire=1581954612&ei=02FKXrbXPNeFpAScr7CwAw&ip=80.232.126.94&id=o-ACxm3qLNwbpL_UaKKNvaw8LWg-tRhrreFP9MDgEf1YFq&itag=18&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&gir=yes&clen=563851691&ratebypass=yes&dur=7297.195&lmt=1579098922861711&fvip=3&fexp=23842630,23872989&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=ALgxI2wwRQIhAJn2lFmusupwAxSxmT0zvXZ6XRmNiXJBbmpn18emmnU9AiAGPCfXXoBkV-vE1TSvx034lX6RhbcYidmNbiQD9Sf8UA%3D%3D&video_id=6QbNmB9uMJ8&title=Best+Of+Vocal+Deep+House+Music+Chill+Out+-+Feeling+Relaxing+%233&rm=sn-uqj-j2id7r,sn-5golz7s&req_id=6c435b1b9b31a3ee&redirect_counter=2&cms_redirect=yes&ipbypass=yes&mip=2003:e8:371e:a401:4d6d:d956:7d5c:3984&mm=29&mn=sn-h0jeln7k&ms=rdu&mt=1581935046&mv=u&mvi=2&pl=36&lsparams=ipbypass,mip,mm,mn,ms,mv,mvi,pl&lsig=AHylml4wRgIhAJEKQkwoQsvDH4MtMv7vbjwoTRdltZWu7iu80eJa0vSPAiEAy9vjmCXZRiBU-PcmqwPF7wHUOVCqTDMblhAnINpn0hg%3D';
    url = 'blob:https://www.youtube.com/70e634cc-dd41-43a3-8559-2aa5f39d3781';
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
