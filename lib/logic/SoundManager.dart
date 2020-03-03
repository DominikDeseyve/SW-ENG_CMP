import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:flutter/foundation.dart';
import 'package:media_notification_control/media_notification.dart';

class SoundManager extends ChangeNotifier {
  AudioPlayer _audioPlayer;
  Queue _playingQueue;
  Playlist _playlingPlaylist;
  StreamSubscription _onSongEnd;
  Song _currentSong;

  SoundManager() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    this._audioPlayer.setVolume(1);
    /* this._audioPlayer.onAudioPositionChanged.listen((Duration pPosition) {
      this._audioPlayer.getDuration().then((int pLength) {
        //convert units to milliseconds
        int relativPos = pLength - pPosition.inMilliseconds;
        if (relativPos < 1000 * 10) {
          //load More
        }
      });
    });*/
    this._onSongEnd = this._audioPlayer.onPlayerCompletion.listen((_) async {
      print("SOUND ENDED");
      await this._currentSong.end();
      this.prepareNextSongs(2).then((_) {
        this.nextSong().then((bool hasNext) {
          if (hasNext) {
            this.play();
          } else {
            this.notifyListeners();
          }
        });
      });
    });
  }

  Future<void> _loadSong() async {
    await this._audioPlayer.setUrl(this.currentSong.soundURL);
  }

  void play() async {
    await this._audioPlayer.resume();
    this._currentSong.play();

    MediaNotification.setListener('pause', () {
      this.pause();
    });
    MediaNotification.setListener('play', () {
      this.play();
    });

    MediaNotification.setListener('next', () {
      this.nextSong();
    });

    await MediaNotification.show(
      play: true,
      title: this.currentSong.titel,
      author: this.currentSong.artist,
    );

    this.notifyListeners();
  }

  Future<void> pause() async {
    await this._audioPlayer.pause();
    this.notifyListeners();
  }

  void seek(Duration pPosition) async {
    await this._audioPlayer.seek(pPosition);
  }

  Future<void> prepareNextSongs(int pLength) async {
    print("prepare next " + pLength.toString() + " song(s)");

    if (this._playingQueue.songs.length < pLength) {
      pLength = this._playingQueue.songs.length;
    }
    for (int i = 0; i < pLength; i++) {
      if (this._playingQueue.length - 1 < i) {
        this._playingQueue.loadMore();
      }
      if (this._playingQueue.songs[i].soundURL == null) {
        await this._playingQueue.songs[i].loadURL();
      }
    }
  }

  Future<bool> nextSong() async {
    print("skip Song");
    if (this._playingQueue.songs.length == 0) {
      print("--- PLAYLIST STOPPED BECAUSE NO MORE SONGS FOUND");
      await this.pause();
      return false;
    }
    await this._audioPlayer.pause();
    await this.prepareNextSongs(1);

    //change song
    this._currentSong.end();
    this._currentSong = this._playingQueue.skip();
    this._currentSong.play();
    await this._loadSong();
    await this._audioPlayer.resume();
    this.notifyListeners();
    await this.prepareNextSongs(2);
    return true;
  }

  Future<bool> setQueue(Queue pQueue, Playlist pPlaylist) async {
    this._playingQueue = pQueue;

    this._playlingPlaylist = pPlaylist;
    if (this._playingQueue.currentSong is Song) {
      this._currentSong = this._playingQueue.currentSong;
    } else if (this._playingQueue.songs.length == 0) {
      return false;
    } else {
      this._currentSong = this._playingQueue.songs[0];
    }

    await this._currentSong.loadURL();
    await this._loadSong();
    this.play();

    this.prepareNextSongs(2);
    return true;
  }

  Future<void> deleteQueue() async {
    await this.pause();
    this._currentSong.open();

    this._playingQueue = null;
    this._playlingPlaylist = null;
    this._currentSong = null;
  }

  void dispose() {
    print("dispose soundManager");
    this._currentSong.end();
    this._audioPlayer.release();
    this._onSongEnd.cancel();
    super.dispose();
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

  Playlist get playlist {
    return this._playlingPlaylist;
  }

  Song get currentSong {
    if (this._playingQueue != null) {
      return this._currentSong;
    }
    return null;
  }
}
