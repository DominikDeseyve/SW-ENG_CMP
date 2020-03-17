import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/models/genre.dart';
import 'package:intl/intl.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/models/visibleness.dart';

class Playlist {
  String _playlistID;
  String _name;
  int _maxAttendees;
  int _joinedUserCount;
  int _queuedSongCount;
  Visibleness _visibleness;
  String _description;
  String _imageURL;
  List<Genre> _blackedGenre;
  User _creator;
  DateTime _createdAt;

  Playlist() {
    this._joinedUserCount = 0;
    this._queuedSongCount = 0;
    this._createdAt = DateTime.now();
  }

  Playlist.fromFirebase(DocumentSnapshot pSnap, {bool short = false}) {
    this._playlistID = pSnap.documentID;
    this._name = pSnap['name'];
    this._imageURL = pSnap['image_url'];

    if (!short) {
      this._maxAttendees = pSnap['max_attendees'];
      this._description = pSnap['description'];
      this._visibleness = Visibleness(pSnap['visibleness']);
      this._joinedUserCount = pSnap['joined_user_count'];
      this._queuedSongCount = pSnap['queued_song_count'];
      //this.blackedGenre = pSnap[''];
      this._creator = User.fromFirebase(pSnap['creator']);
      this._createdAt = DateTime.fromMillisecondsSinceEpoch(pSnap['created_at'].seconds * 1000);
    }
  }

  Map<String, dynamic> toFirebase({bool short = false}) {
    if (short) {
      return {
        'playlist_id': this._playlistID,
        'name': this._name,
        'image_url': this._imageURL,
        'creator': this.creator.toFirebase(short: true),
      };
    } else {
      return {
        'name': this.name,
        'image_url': this.imageURL,
        'max_attendees': this.maxAttendees,
        'description': this.description,
        'visibleness': this.visibleness.key,
        //'blacked_genre': this.blackedGenre.map((genre) => genre.toFirebase()).toList(),
        'creator': this.creator.toFirebase(short: true),
        'keywords': Firebase.generateKeywords([this.name]),
        'joined_user_count': this._joinedUserCount,
        'queued_song_count': this._queuedSongCount,
        'created_at': this._createdAt,
      };
    }
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

  int get joinedUserCount {
    return this._joinedUserCount;
  }

  String get description {
    return this._description;
  }

  int get queuedSongCount {
    return this._queuedSongCount;
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

  String get createdAtString {
    return DateFormat("EEEE - dd. MMMM yyyy").format(this._createdAt);
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

  set description(String pDescription) {
    this._description = pDescription;
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
