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
  List<StreamSubscription<QuerySnapshot>> _streamSubscription = [];

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

  Song _copySoundURL(Song pSong) {
    int index = this._songs.indexWhere((item) => item.songID == pSong.songID);
    if (index > -1) {
      pSong.soundURL = this._songs[index].soundURL;
    } else if (this._currentSong != null && this._currentSong.soundURL != null && this._currentSong.songID == pSong.songID) {
      pSong.soundURL = this._currentSong.soundURL;
    }
    return pSong;
  }

  void listen() {
    this._stream = Controller().firebase.getPlaylistQueue(this._playlist, this);

    this._streamSubscription.add(this._stream.listen((QuerySnapshot pQuery) {
          print("STREAM LISTENER -- QUEUE FETCHED " + pQuery.documentChanges.length.toString() + " SONGS");
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
            song = this._copySoundURL(song);

            if (song.songStatus.isPlaying && pSong.type != DocumentChangeType.removed) {
              this._currentSong = song;
              this._removeSong(song);
              return;
            }
            switch (pSong.type) {
              case DocumentChangeType.added:
                print('ADD: ' + song.titel);
                int index = this._songs.indexWhere((item) => item.songID == song.songID);
                if (index == -1) {
                  //if song is was current song
                  if (this._currentSong != null && this._currentSong.songID == song.songID) {
                    print("ist das wirklich nötig?");
                    this._currentSong = null;
                  }
                  this._songs.add(song);
                }
                break;
              case DocumentChangeType.modified:
                print("MODIFIED: " + song.titel);

                int index = this._songs.indexWhere((item) => item.songID == song.songID);
                if (index > -1) {
                  this._songs[index] = song;
                } else {
                  this._songs.add(song);
                  this._currentSong = null;
                }

                break;
              case DocumentChangeType.removed:
                print("REMOVED: " + song.titel);
                this._currentSong = null;
                this._removeSong(song);
                break;
            }
          });
          this.sort();
          this._callback(pQuery);
        }));
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

  void skip() {
    if (this.hasNextSong) {
      this._currentSong = this.nextSong;
      this._songs.removeAt(0);
    }
  }

  void cancel() {
    this._streamSubscription.forEach((StreamSubscription pSub) {
      pSub.cancel();
      pSub = null;
    });
    this._streamSubscription = null;
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
    if (this.currentSong is Song) {
      return this._songs.length + 1;
    } else {
      return this._songs.length;
    }
  }

  bool get hasNextSong {
    return (this._songs.length > 0);
  }

  Song get currentSong {
    return this._currentSong;
  }

  Song get nextSong {
    return this._songs[0];
  }
}
