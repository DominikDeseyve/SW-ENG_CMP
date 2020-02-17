import 'package:cmp/models/song.dart';

class Queue {
  List<Song> _songs = [];
  int _index;

  Queue() {
    this._index = 0;
  }

  void _sort() {}

  void skipSong() {}

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  List<Song> get songs {
    return this._songs;
  }

  Song get currentSong {
    return this._songs[this._index];
  }
}
