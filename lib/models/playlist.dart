import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';

class Playlist {
  String _playlistID;
  String _name;
  int _maxAttendees;
  Visibleness _visibleness;
  String _imageURL;
  List<Genre> _blackedGenre;
  User _creator;

  Playlist() {}

  Playlist.fromFirebase(DocumentSnapshot pSnap) {
    this._playlistID = pSnap.documentID;
    this._name = pSnap['name'];
    this._maxAttendees = pSnap['max_attendees'];
    this._visibleness = Visibleness(pSnap['visibleness']);
    this._imageURL = pSnap['image_url'];
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get playlistID {
    return this._playlistID;
  }

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

  String get imageURL {
    return this._imageURL;
  }

  User get creator {
    return this._creator;
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set playlistID(String pPlaylistID) {
    this._playlistID = pPlaylistID;
  }

  set name(String pName) {
    this._name = pName;
  }

  set imageURL(String pImageURL) {
    this._imageURL = pImageURL;
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

  set creator(User pCreator) {
    this._creator = pCreator;
  }
}
