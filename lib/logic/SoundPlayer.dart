import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/logic/Queue.dart';
import 'package:flutter/foundation.dart';

class SoundPlayer extends ChangeNotifier {
  AudioPlayer _audioPlayer;

  Queue _playingQueue;
  Playlist _playlingPlaylist;

  Song _currentSong;

  SoundPlayer() {
    this._audioPlayer = AudioPlayer();
    AudioPlayer.logEnabled = false;
    this._audioPlayer.setVolume(1);
    this._audioPlayer.onPlayerCompletion.listen((_) {
      print("SOUND ENDED");
      this.nextSong().then((bool hasNext) {
        if (hasNext) {
          this.play();
        }
      });
    });
  }

  Future<void> _loadSong() async {
    await this._audioPlayer.setUrl(this.currentSong.soundURL);
  }

  void play() async {
    AudioCache audioCache = new AudioCache();
    //audioCache.load('://r2---sn-p5qlsndk.googlevideo.com/videoplayback?expire=1582675521&ei=4WFVXrOzH8vj8gSkyrnIAQ&ip=54.204.79.209&id=o-AM5HysUNUG7YP94gTsAko_BGF5gvnBwTSlQvjwS1bWMl&itag=18&source=youtube&requiressl=yes&mm=31%2C26&mn=sn-p5qlsndk%2Csn-vgqskn7l&ms=au%2Conr&mv=u&mvi=1&pl=24&vprv=1&mime=video%2Fmp4&gir=yes&clen=12980855&ratebypass=yes&dur=176.332&lmt=1574751525864896&mt=1582653414&fvip=2&fexp=23842630%2C23878762&c=WEB&txp=3531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl&lsig=AHylml4wRgIhAKH7ma1GdrYhy3JnvMgof42cJd7O0W82dAyrztQ2x6suAiEA5VapWHZuNClcgv9IvZrtJX4nrswUnHMZc5wRff0b2GI%3D&sig=ALgxI2wwRQIge-2DL9WBuwSMYWKPRlQGdxcoOAUkz5739IGK-q90PEECIQCyMJ_0gLwVwKrT3UmfAYG9RAX3eqKZNQOrhL_jEccgqQ==');
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
    this._currentSong.songStatus.end();
    Controller().firebase.updateSong(this._playlingPlaylist, this._currentSong);
    this._currentSong = this._playingQueue.skip();
    this._currentSong.songStatus.play();
    Controller().firebase.updateSong(this._playlingPlaylist, this._currentSong);
    await this._loadSong();
    await this._audioPlayer.resume();
    this.notifyListeners();
    await this.prepareNextSongs(2);
    return true;
  }

  void setQueue(Queue pQueue, Playlist pPlaylist) {
    this._playingQueue = pQueue;
    this._playlingPlaylist = pPlaylist;
    if (this._playingQueue.currentSong != null) {
      this._currentSong = this._playingQueue.currentSong;
    } else {
      this._currentSong = this._playingQueue.songs[0];
    }

    this._currentSong.songStatus.play();
    Controller().firebase.updateSong(pPlaylist, this._currentSong);
    this._currentSong.loadURL().then((_) {
      this._loadSong().then((_) {
        this.play();
      });
    });
    this.prepareNextSongs(2);
  }

  Future<void> deleteQueue() async {
    await this.pause();
    this._currentSong.songStatus.end();
    Controller().firebase.updateSong(this._playlingPlaylist, this._currentSong);

    this._playingQueue = null;
    this._playlingPlaylist = null;
    this._currentSong = null;
  }

  void dispose() {
    this._audioPlayer.release();
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
