import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/CrossfadeTimer.dart';
import 'package:cmp/logic/Player.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:flutter/foundation.dart';
import 'package:media_notification_control/media_notification.dart';

class SoundManager extends ChangeNotifier {
  Queue _playingQueue;
  Playlist _playlingPlaylist;
  StreamSubscription _onSongEnd;
  StreamSubscription _onPositionChange;

  Player _activePlayer;
  Player _passivePlayer;

  CrossfadeTimer _crossfadeTimer;

  SoundManager() {
    this._activePlayer = new Player();
    this._passivePlayer = new Player();

    this._crossfadeTimer = new CrossfadeTimer(this._crossfadeTimerInterval);
    this._initStreams();
  }

  void _crossfadeTimerInterval(int pTick) async {
    print("CROSSFADE-TIMER: " + pTick.toString());
    int crossfade = Controller().authentificator.user.settings.crossfade;
    double decVolume = (pTick / crossfade);
    double incVolume = 1.0 - (pTick / crossfade);

    if (pTick == crossfade - 1) {
      this._switchPlayer();
      this._initStreams();
      this._playingQueue.skip();
      this._passivePlayer.song.end();
      this._activePlayer.volume = incVolume;
      this._passivePlayer.volume = decVolume;
      await this.play();
      this._activePlayer.song.play();
    } else if (pTick <= 0) {
      this._activePlayer.volume = incVolume;
      this._passivePlayer.volume = decVolume;
      await this._passivePlayer.pause();
      this._crossfadeTimer.stop();
    } else if (pTick <= crossfade - 1) {
      this._activePlayer.volume = incVolume;
      this._passivePlayer.volume = decVolume;
    }
  }

  Future<void> _initStreams() async {
    if (this._onPositionChange != null) {
      await this._onPositionChange.cancel();
      this._onPositionChange = null;
    }
    this._onPositionChange = this._activePlayer.durationStream.listen((Duration pPosition) {
      this._activePlayer.fetchDuration().then((int pDuration) {
        int differenzPos = pDuration - pPosition.inMilliseconds;
        if (differenzPos <= 1000 * Controller().authentificator.user.settings.crossfade && !this._crossfadeTimer.isActivated && this._playingQueue.hasNextSong) {
          print("-- STARTING CROSSFADE");
          this._loadNextSong();
          this._crossfadeTimer.start();
        }
      });
    });
    if (this._onSongEnd != null) {
      await this._onSongEnd.cancel();
      this._onSongEnd = null;
    }

    this._onSongEnd = this._activePlayer.onPlayerCompletion.listen((_) async {
      print("SOUND ENDED");
      this.nextSong();
    });
  }

  Future<void> _loadNextSong() async {
    if (this._playingQueue.hasNextSong) {
      Song nextSong = this._playingQueue.nextSong;
      await this._passivePlayer.initSong(nextSong);
    }
  }

  Future<void> play() async {
    await this._activePlayer.play();
    if (this._crossfadeTimer.isActivated) {
      await this._passivePlayer.play();
    }
    this._crossfadeTimer.resume();
    this._activePlayer.song.play();

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
    await this._activePlayer.pause();
    if (this._crossfadeTimer.isActivated) {
      await this._passivePlayer.pause();
    }
    this._crossfadeTimer.pause();

    await MediaNotification.show(
      play: false,
      title: this.currentSong.titel,
      author: this.currentSong.artist,
    );
    this.notifyListeners();
  }

  Future<void> stop() async {
    await this._activePlayer.pause();
    this._crossfadeTimer.stop();
    this._activePlayer.song.end();

    this.notifyListeners();
  }

  void seek(Duration pPosition) async {
    await this._activePlayer.seek(pPosition);
  }

  Future<void> prepareNextSongs(int pLength) async {
    print("prepare next " + pLength.toString() + " song(s)");

    if (this._playingQueue.songs.length < pLength) {
      pLength = this._playingQueue.songs.length;
    }
    //temp
    if (this._playingQueue.currentSong != null && this._playingQueue.currentSong.soundURL == null) {
      print("hier2");
      await this._playingQueue.currentSong.loadURL();
    }
    //temp end
    for (int i = 0; i < pLength; i++) {
      if (this._playingQueue.songs.length - 1 < i) {
        this._playingQueue.loadMore();
      }
      if (this._playingQueue.songs[i].soundURL == null) {
        await this._playingQueue.songs[i].loadURL();
      }
    }
  }

  Future<bool> nextSong() async {
    print(this._playingQueue.currentSong.soundURL);
    print("next Song");
    //this._crossfadeTimer.stop();
    if (!this._playingQueue.hasNextSong) {
      print("--- PLAYLIST STOPPED BECAUSE NO MORE SONGS FOUND");
      await this.pause();
      return false;
    }

    await this.prepareNextSongs(1);
    await this._loadNextSong();
    this._playingQueue.skip();

    await this.stop();
    await this._switchPlayer();
    await this._initStreams();
    await this.play();

    await MediaNotification.show(
      play: true,
      title: this.currentSong.titel,
      author: this.currentSong.artist,
    );

    this.prepareNextSongs(2);
    return true;
  }

  Future<void> setQueue(Queue pQueue, Playlist pPlaylist) async {
    this._playingQueue = pQueue;
    this._playlingPlaylist = pPlaylist;

    //if song is already playing
    if (this._playingQueue.currentSong == null) {
      this._playingQueue.skip();
    }
    await this.prepareNextSongs(1);
    await this._passivePlayer.initSong(this._playingQueue.currentSong);

    await this._switchPlayer();
    await this._initStreams();
    await this.play();

    this.prepareNextSongs(1);
  }

  Future<void> deleteQueue() async {
    await this.pause();
    print(this._activePlayer.song.titel);
    this._crossfadeTimer.stop();
    this._activePlayer.song.open();

    this._playingQueue = null;
    this._playlingPlaylist = null;
    this._activePlayer = new Player();
    this._passivePlayer = new Player();
    MediaNotification.hide();
  }

  Future<void> _switchPlayer() async {
    Player tmp = this._activePlayer;
    this._activePlayer = this._passivePlayer;
    this._passivePlayer = tmp;
  }

  void dispose() {
    print("dispose soundManager");
    this._activePlayer.song.end();
    this._passivePlayer.pause();
    this._onSongEnd.cancel();
    this._onPositionChange.cancel();
    super.dispose();
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//

  AudioPlayerState get state {
    return this._activePlayer.state;
  }

  Stream<Duration> get durationStream {
    return this._activePlayer.durationStream;
  }

  Future<int> get duration async {
    return await this._activePlayer.fetchDuration();
  }

  Stream<double> get percentage async* {
    if (this._activePlayer.hasSong) {
      Stream<Duration> position = this._activePlayer.durationStream;
      await for (var dur in position) {
        int length = await this._activePlayer.fetchDuration();
        double percentage = (dur.inMilliseconds / length).toDouble();
        yield percentage;
      }
    } else {
      yield 0.0;
    }

    //TODO
    //return percentage for slider
  }

  Queue get queue {
    return this._playingQueue;
  }

  Playlist get playlist {
    return this._playlingPlaylist;
  }

  Song get currentSong {
    if (this._playingQueue != null) {
      return this._activePlayer.song;
    }
    return null;
  }
}
