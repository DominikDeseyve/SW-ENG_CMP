import 'package:cmp/models/role.dart';
import 'package:cmp/models/settings.dart';
import 'package:cmp/models/song.dart';

class User {
  String _userID;
  String _username;

  DateTime _birthday;
  String _imageURL;
  Role _role;
  List<String> _upvotedSongs;
  List<String> _downvotedSongs;

  Settings _settings;

  User() {}

  User.fromFirebase(var pSnapOrMap) {
    if (pSnapOrMap['user_id'] != null) {
      this._userID = pSnapOrMap['user_id'];
    } else {
      this._userID = pSnapOrMap.documentID;
    }
    this._username = pSnapOrMap['username'];
    this._imageURL = pSnapOrMap['image_url'];
    if (pSnapOrMap['birthday'] != null) {
      this._birthday = DateTime.fromMillisecondsSinceEpoch(pSnapOrMap['birthday'].seconds * 1000);
    }

    if (pSnapOrMap['role'] != null) {
      this._role = Role.fromFirebase(pSnapOrMap['role']);
    }
    if (pSnapOrMap['upvotes'] != null) {
      this._upvotedSongs = List.from(pSnapOrMap['upvotes']);
      this._downvotedSongs = List.from(pSnapOrMap['downvotes']);
    }
  }

  Map<String, dynamic> toFirebase() => {
        'user_id': this._userID,
        'username': this._username,
        'birthday': this._birthday,
        'image_url': this._imageURL,
      };
  void thumbUpSong(Song pSong) {
    this._downvotedSongs.remove(pSong.songID);
    this._upvotedSongs.add(pSong.songID);
  }

  void thumbDownSong(Song pSong) {
    this._upvotedSongs.remove(pSong.songID);
    this._downvotedSongs.add(pSong.songID);
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//
  set userID(String pUserID) {
    this._userID = pUserID;
  }

  set username(String pUsername) {
    this._username = pUsername;
  }

  set birthday(DateTime pBirthday) {
    this._birthday = pBirthday;
  }

  set settings(Settings pSettings) {
    this._settings = pSettings;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//

  Settings get settings {
    return this._settings;
  }

  String get userID {
    return this._userID;
  }

  String get username {
    return this._username;
  }

  DateTime get birthday {
    return this._birthday;
  }

  Role get role {
    return this._role;
  }

  String get imageURL {
    return this._imageURL;
  }

  List<String> get upvotedSongs {
    return this._upvotedSongs;
  }

  List<String> get downvotedSongs {
    return this._downvotedSongs;
  }
}
