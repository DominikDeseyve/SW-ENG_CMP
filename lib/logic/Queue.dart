import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';

class Queue {
  int _stepSize;
  Function(QuerySnapshot) _callback;
  bool _isFinished;
  DocumentSnapshot _lastDocument;
  Stream<QuerySnapshot> _stream;
  StreamSubscription<QuerySnapshot> _streamSubscription;

  Song _currentSong;
  List<Song> _songs = [];
  Playlist _playlist;

  Queue(Playlist pPlaylist) {
    this._playlist = pPlaylist;
    this._stepSize = 6;
    this._isFinished = false;
    this._lastDocument = null;
  }

  void setCallback(Function pCallback) {
    this._callback = pCallback;
    this.listen();
  }

  void loadMore() {
    if (!this._isFinished) {
      print("LOAD MORE");
      this.listen();
    }
  }

  void listen() {
    this._stream = Controller().firebase.getPlaylistQueue(this._playlist, this);

    this._streamSubscription = this._stream.listen((QuerySnapshot pQuery) {
      if (pQuery.documentChanges.length == 0) {
        this._isFinished = true;
        return;
      } else if (pQuery.documentChanges.length < this._stepSize) {
        this._isFinished = true;
      } else {
        //pQuery.documentChanges.length = this._stepSize;
      }
      this._lastDocument = pQuery.documentChanges.last.document;

      pQuery.documentChanges.forEach((DocumentChange pSong) {
        Song song = Song.fromFirebase(pSong.document, this._playlist);
        if (song.songStatus.isPlaying) {
          this._currentSong = song;
          this._removeSong(song);
          return;
        }
        print(song.titel);
        switch (pSong.type) {
          case DocumentChangeType.added:
            print('ADD: ' + song.titel);
            int index = this._songs.indexWhere((item) => item.songID == song.songID);
            if (index == -1) {
              //if song is was current song
              if (this._currentSong != null && this._currentSong.songID == song.songID) {
                this._currentSong = null;
              }
              this._songs.add(song);
            }
            break;
          case DocumentChangeType.modified:
            print("modiefied");

            int index = this._songs.indexWhere((item) => item.songID == song.songID);
            if (index > -1) {
              this._songs[index] = song;
            } else {
              this._songs.add(song);
              this._currentSong = null;
            }

            break;
          case DocumentChangeType.removed:
            print("removed");
            this._removeSong(song);
            break;
        }
      });
      this.sort();
      this._callback(pQuery);
      if (Controller().soundManager.playlist != null) {
        if (Controller().soundManager.playlist.playlistID == this._playlist.playlistID) {
          Controller().soundManager.prepareNextSongs(1);
        }
      }
    });
  }

  void _removeSong(Song pSong) {
    int index = this._songs.indexWhere((item) => item.songID == pSong.songID);
    if (index > -1) {
      this._songs.removeAt(index);
    }
  }

  void sort() {
    this._songs.sort((a, b) {
      var r = b.ranking.compareTo(a.ranking);
      if (r != 0) return r;
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  Song skip() {
    this._currentSong = this._songs[0];
    this._songs.removeAt(0);
    return this._currentSong;
  }

  void cancel() {
    this._streamSubscription.cancel();
  }

  void dispose() {
    this.cancel();
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//

  int get stepSize {
    return this._stepSize;
  }

  DocumentSnapshot get lastDocument {
    return this._lastDocument;
  }

  List<Song> get songs {
    return this._songs;
  }

  int get length {
    return this._songs.length;
  }

  Song get currentSong {
    if (this._currentSong == null) {
      if (this._songs.length == 0) {
        return null;
      }
      if (this._songs[0].songStatus.isPlaying) {
        this._currentSong = this._songs[0];
        this._songs.removeAt(0);
      } else {
        return null;
      }
    }
    return this._currentSong;
  }
}
