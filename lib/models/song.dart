import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/logic/HTTP.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song_status.dart';
import 'package:cmp/models/user.dart';
import 'package:html_unescape/html_unescape_small.dart';

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
  SongStatus _songStatus;

  Playlist _playlist;

  bool _isUpvoting;
  bool _isDownvoting;

  Song.fromYoutube(dynamic pItem) {
    this._youTubeID = pItem['id']['videoId'];
    this._titel = new HtmlUnescape().convert(pItem['snippet']['title']);
    this._artist = pItem['snippet']['channelTitle'];
    this._imageURL = pItem['snippet']['thumbnails']['high']['url'];
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.username;
    this._creator = creator;
    this._songStatus = new SongStatus();
  }
  Song.fromFirebase(DocumentSnapshot pSnap, Playlist pPlaylist) {
    this._playlist = pPlaylist;

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
    this._songStatus = SongStatus.fromFirebase(pSnap['song_status']);
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
      'creator': this._creator.toFirebase(),
      'song_status': this._songStatus.toFirebase(),
    };
  }

  Future<void> loadURL() async {
    return await HTTP.getSoundURL(this._youTubeID).then((String pURL) {
      print("URL LOADED: " + pURL);
      this._soundURL = pURL;
    });
  }

  Future<void> _updateStatus() async {
    await Controller().firebase.updateSongStatus(this._playlist, this);
  }

  void play() {
    this._songStatus.status = 'PLAYING';
    this._updateStatus();
  }

  void open() {
    this._songStatus.status = 'OPEN';
    this._updateStatus();
  }

  Future<void> end() async {
    this._songStatus.status = 'END';
    await this._updateStatus();
  }

  void voteUp() {
    if (this.isDownvoting) {
      this.downvoteCount -= 1;
    }
    this.upvoteCount += 1;
  }

  void voteDown() {
    if (this.isUpvoting) {
      this.upvoteCount -= 1;
    }
    this.downvoteCount += 1;
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//

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

  String get youTubeID {
    return this._youTubeID;
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

  SongStatus get songStatus {
    return this._songStatus;
  }
}
