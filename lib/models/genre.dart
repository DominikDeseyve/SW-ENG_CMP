import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  String _genreID;
  String _imageURL;
  String _name;
  String _subname;

  Genre.fromFirebase(DocumentSnapshot pSnap) {
    this._genreID = pSnap.documentID;
    this._name = pSnap['name'];
    this._subname = pSnap['subname'];
    this._imageURL = pSnap['image_url'];
  }

  Map<String, dynamic> toFirebase() => {
        'genre_id': this._genreID,
        'name': this._name,
        'subname': this._subname,
        'image_url': this._imageURL,
      };
  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get name {
    return this._name;
  }

  String get subname {
    return this._subname;
  }

  String get imageURL {
    return this._imageURL;
  }
}
