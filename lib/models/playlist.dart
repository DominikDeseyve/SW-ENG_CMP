import 'package:cmp/models/genre.dart';
import 'package:cmp/models/visibleness.dart';

class Playlist {
  String _playlistID;
  String _name;
  int _maxAttendees;
  Visibleness _visibleness;
  List<Genre> _blackedGenre;

  Playlist() {}

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get name {
    return this._name;
  }

  int get maxAttendees {
    return this._maxAttendees;
  }

  List<Genre> get blackedGenre {
    return this._blackedGenre;
  }

  Visibleness get visibleness {
    return this._visibleness;
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set name(String pName) {
    this._name = pName;
  }

  set maxAttendees(int pMaxAttendees) {
    this._maxAttendees = pMaxAttendees;
  }

  set visibleness(Visibleness pVisibleness) {
    this._visibleness = pVisibleness;
  }

  set blackedGenre(List<Genre> pBlackedGenre) {
    this._blackedGenre = pBlackedGenre;
  }
}
