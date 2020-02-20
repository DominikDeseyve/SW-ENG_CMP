import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/HTTP.dart';
import 'package:cmp/models/user.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:youtube_api/youtube_api.dart';

class Song {
  String _songID;
  String _titel;
  String _artist;
  String _youTubeID;
  String _soundURL;
  String _imageURL;
  double _ranking;
  User _creator;
  DateTime _createdAt;
  int _upvoteCount;
  int _downvoteCount;

  Song.fromYoutube(YT_API pItem) {
    this._artist = pItem.channelTitle;
    this._titel = new HtmlUnescape().convert(pItem.title);
    this._imageURL = pItem.thumbnail['high']['url'];
    this._youTubeID = pItem.id;
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.userID;
    this._creator = creator;
  }
  Song.fromFirebase(DocumentSnapshot pSnap) {
    this._songID = pSnap.documentID;
    this._titel = pSnap['titel'];
    this._artist = pSnap['artist'];
    this._youTubeID = pSnap['youtube_id'];
    this._imageURL = pSnap['image_url'];
    this._ranking = double.parse(pSnap['ranking'].toString());
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(pSnap['created_at'].seconds * 1000);
    this._creator = new User.fromFirebase(pSnap['creator']);
    this._downvoteCount = pSnap['downvote_count'];
    this._upvoteCount = pSnap['upvote_count'];
    //this.loadURL();
  }
  Map<String, dynamic> toFirebase() {
    return {
      'titel': this._titel,
      'artist': this._artist,
      'image_url': this._imageURL,
      'youtube_id': this._youTubeID,
      'ranking': 1,
      'created_at': DateTime.now(),
      'upvote_count': 0,
      'downvote_count': 0,
      'time': -1,
      'creator': this._creator.toFirebase(),
    };
  }

  Future<void> loadURL() async {
    return await HTTP.getSoundURL(this._youTubeID).then((String pURL) {
      print("URL LOADED: " + pURL);
      this._soundURL = pURL;
    });
  }

  set upvoteCount(int pNr) {
    this._upvoteCount = pNr;
  }

  set downvoteCount(int pNr) {
    this._downvoteCount = pNr;
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

  User get creator {
    return this._creator;
  }
}
