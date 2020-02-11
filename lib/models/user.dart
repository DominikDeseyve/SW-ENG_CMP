import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/settings.dart';

class User {
  String _userID;
  String _username;
  DateTime _birthday;
  String _imageURL;

  Settings _settings;

  User() {}

  User.fromFirebase(DocumentSnapshot pSnap) {
    this._userID = pSnap.documentID;
    this._birthday = DateTime.fromMillisecondsSinceEpoch(pSnap['birthday'].seconds * 1000);
    this._username = pSnap['username'];
    this._imageURL = pSnap['image_url'];
  }

  Map<String, dynamic> toFirebase() => {
        'user_id': this._userID,
        'username': this._username,
        'birthday': this._birthday,
        'image_url': this._imageURL,
      };
}
