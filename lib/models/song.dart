import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_api/youtube_api.dart';

class Song {
  String _titel;
  String _soundURL;
  String _imageURL;

  Song.fromYoutube(YT_API pItem) {
    this._titel = pItem.title;
    this._imageURL = pItem.thumbnail['high']['url'];
    this._soundURL = pItem.url.replaceAll(' ', '');
    print('ID: ' + pItem.id);
  }
  Song.fromFirebase(DocumentSnapshot pSnap) {
    this._titel = pSnap['titel'];
    this._soundURL = pSnap['sound_url'];
    this._imageURL = pSnap['image_url'];
  }
  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get titel {
    return this._titel;
  }

  String get soundURL {
    return this._soundURL;
  }

  String get imageURL {
    return this._imageURL;
  }
}
