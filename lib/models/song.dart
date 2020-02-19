import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/HTTP.dart';
import 'package:youtube_api/youtube_api.dart';

class Song {
  String _songID;
  String _titel;
  String _artist;
  String _youTubeURL;
  String _soundURL;
  String _imageURL;
  double _ranking;
  DateTime _createdAt;
  int _upvoteCount;
  int _downvoteCount;

  Song.fromYoutube(YT_API pItem) {
    this._titel = pItem.title;
    this._imageURL = pItem.thumbnail['high']['url'];
    this._youTubeURL = pItem.url.replaceAll(' ', '');
  }
  Song.fromFirebase(DocumentSnapshot pSnap) {
    this._songID = pSnap.documentID;
    this._titel = pSnap['titel'];
    this._artist = pSnap['artist'];
    this._youTubeURL = pSnap['youtube_url'];
    this._imageURL = pSnap['image_url'];
    this._ranking = double.parse(pSnap['ranking'].toString());
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(pSnap['created_at'].seconds * 1000);
    this._downvoteCount = pSnap['downvote_count'];
    this._upvoteCount = pSnap['upvote_count'];
    //this.loadURL();
  }
  Map<String, dynamic> toFirebase() {
    return {
      'titel': this._titel,
      'artist': this._artist,
      'image_url': this._imageURL,
      'youtube_url': this._youTubeURL,
      'ranking': 1,
      'created_at': DateTime.now(),
      'upvote_count': 0,
      'downvote_count': 0,
      'time': -1,
    };
  }

  Future<void> loadURL() async {
    return await HTTP.getSoundURL('31kEycTIXnI').then((String pURL) {
      print("URL LOADED: " + pURL);
      this._soundURL = pURL;
    });
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get songID {
    return this._songID;
  }

  String get titel {
    return this._titel;
  }

  String get artist {
    return this._artist;
  }

  String get soundURL {
    return this._soundURL;
  }

  String get imageURL {
    return this._imageURL;
  }

  double get ranking {
    return this._ranking;
  }

  DateTime get createdAt {
    return this._createdAt;
  }

  bool get isUpvoting {
    return Controller().authentificator.user.upvotedSongs.contains(this._songID);
  }

  bool get isDownvoting {
    return Controller().authentificator.user.downvotedSongs.contains(this._songID);
  }

  int get downvoteCount {
    return this._downvoteCount;
  }

  int get upvoteCount {
    return this._upvoteCount;
  }
}
