import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/settings.dart';

class User {
  String _userID;
  String _username;
  DateTime _birthday;
  String _imageURL;
  Role _role;

  Settings _settings;

  User() {}

  User.fromFirebase(var pSnapOrMap) {
    if (pSnapOrMap['user_id'] != null) {
      this._userID = pSnapOrMap['user_id'];
    } else {
      this._userID = pSnapOrMap.documentID;
    }
    this._birthday = DateTime.fromMillisecondsSinceEpoch(pSnapOrMap['birthday'].seconds * 1000);
    this._username = pSnapOrMap['username'];
    this._imageURL = pSnapOrMap['image_url'];

    if (pSnapOrMap['role'] != null) {
      this._role = Role.fromFirebase(pSnapOrMap['role']);
    }
  }

  Map<String, dynamic> toFirebase() => {
        'user_id': this._userID,
        'username': this._username,
        'birthday': this._birthday,
        'image_url': this._imageURL,
      };

  //***************************************************//
  //*********   SETTER
  //***************************************************//
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
}
