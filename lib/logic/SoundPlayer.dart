import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/models/Queue.dart';
import 'package:cmp/models/song.dart';
import 'package:flutter/foundation.dart';
import 'package:media_notification_control/media_notification.dart';

class SoundPlayer extends ChangeNotifier {
  AudioPlayer _audioPlayer;
  Queue _queue;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;

    this._audioPlayer.onPlayerCompletion.listen((_) {
      print("SOUND ENDED");
      this.skip();
    });
  }

  void _loadSong() {
    this._audioPlayer.setVolume(1);
    this._audioPlayer.setUrl(this._queue.currentSong.soundURL);
  }

  void play() async {
    await this._audioPlayer.resume();

    MediaNotification.setListener('pause', () {
      this.pause();
    });
    MediaNotification.setListener('play', () {
      this.play();
    });

    await MediaNotification.show(
      title: this._queue.currentSong.titel,
      author: this._queue.currentSong.artist,
    );
    this.notifyListeners();
  }

  void pause() async {
    await this._audioPlayer.pause();
    this.notifyListeners();
  }

  void skip() {
    print("skip Song");
    this.pause();
    this._queue.skipSong();
    this._loadSong();
    this.play();
  }

  void startQueue() {
    this._loadSong();
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
  bool get isEmpty {
    return this._queue == null;
  }

  AudioPlayerState get state {
    return this._audioPlayer.state;
  }

  Stream<Duration> get durationStream {
    return this._audioPlayer.onAudioPositionChanged;
  }

  Future<int> get duration {
    return this._audioPlayer.getDuration();
  }

  Queue get queue {
    return this._queue;
  }
}
