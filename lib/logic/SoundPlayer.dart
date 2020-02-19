import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:flutter/foundation.dart';

class SoundPlayer extends ChangeNotifier {
  AudioPlayer _audioPlayer;
  Queue _playingQueue;
  int _index;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    this._playingQueue = null;
    AudioPlayer.logEnabled = false;
    this._audioPlayer.setVolume(1);
    this._index = 0;
    this._audioPlayer.onPlayerCompletion.listen((_) {
      print("SOUND ENDED");
      this.nextSong();
      this.play();
    });
  }

  Future<void> _loadSong() async {
    await this._audioPlayer.setUrl(this.currentSong.soundURL);
  }

  void play() async {
    await this._audioPlayer.resume();

    /*await this._audioPlayer.setNotification(
          title: 'Title',
          artist: 'Apache 207',
          albumTitle: 'Test',
        );*/
/*
    MediaNotification.setListener('pause', () {
      this.pause();
    });
    MediaNotification.setListener('play', () {
      this.play();
    });*/

    /*await MediaNotification.show(
      title: this._queue.currentSong.titel,
      author: this._queue.currentSong.artist,
    );*/

    this.notifyListeners();
  }

  void pause() async {
    await this._audioPlayer.pause();
    this.notifyListeners();
  }

  void seek(Duration pPosition) async {
    await this._audioPlayer.seek(pPosition);
  }

  Future<void> _prepareNextSongs() async {
    print("prepare next song");
    for (int i = this._index; i < this._index + 2; i++) {
      if (this._playingQueue.length - 1 < i) {
        this._playingQueue.loadMore();
      }
      if (this._playingQueue.songs[i].soundURL == null) {
        await this._playingQueue.songs[i].loadURL();
      }
    }
  }

  void nextSong() async {
    print("skip Song");
    //this._index++;
    //delete old song
    this._playingQueue.deleteFirst();
    await this._loadSong();
    this.notifyListeners();
    this._prepareNextSongs();
  }

  void setQueue(Queue pQueue) {
    this._playingQueue = pQueue;
    this._playingQueue.songs[0].loadURL().then((_) {
      this._loadSong().then((_) {
        this.play();
      });
    });
    this._prepareNextSongs();
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

  Queue get queue {
    return this._playingQueue;
  }

  Song get currentSong {
    if (this._playingQueue != null) {
      return this._playingQueue.songs[this._index];
    }
    return null;
  }
}
