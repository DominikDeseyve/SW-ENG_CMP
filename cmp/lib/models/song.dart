import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song_status.dart';
import 'package:cmp/models/user.dart';
import 'package:html_unescape/html_unescape_small.dart';

class Song {
  String _songID;
  String _titel;
  String _artist;
  String _platform;
  String _platformID;
  String _soundURL;
  String _imageURL;
  double _ranking;
  User _creator;
  DateTime _createdAt;
  int _upvoteCount;
  int _downvoteCount;
  SongStatus _songStatus;
  Playlist _playlist;

  int _duration;

  Song.fromYoutube(dynamic pItem) {
    this._platform = 'YOUTUBE';
    this._platformID = pItem['id']['videoId'];
    this._titel = new HtmlUnescape().convert(pItem['snippet']['title']);
    this._artist = pItem['snippet']['channelTitle'];
    this._imageURL = pItem['snippet']['thumbnails']['default']['url'];
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.username;
    this._creator = creator;
    this._songStatus = new SongStatus();
  }
  Song.fromSoundCloud(dynamic pItem) {
    this._platform = 'SOUNDCLOUD';
    this._platformID = pItem['id'].toString();
    this._titel = pItem['title'];
    this._artist = pItem['user']['username'];
    this._imageURL = pItem['user']['avatar_url'];
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.username;
    this._creator = creator;
    this._songStatus = new SongStatus();

    //https://api.soundcloud.com/tracks?q=brassmusix&client_id=oSGk2QGxkm3FzfZxx3SXThrXN2qPpL3M
  }
  Song.fromSpotify(dynamic pItem) {
    this._platform = 'SPOTIFY';
    this._platformID = pItem['id'];
    this._titel = pItem['name'];
    this._artist = pItem['artists'][0]['name'];
    this._imageURL = pItem['album']['images'][0]['url'];
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.username;
    this._creator = creator;
    this._songStatus = new SongStatus();

    //https://api.soundcloud.com/tracks?q=brassmusix&client_id=oSGk2QGxkm3FzfZxx3SXThrXN2qPpL3M
  }
  Song.fromFirebase(DocumentSnapshot pSnap, Playlist pPlaylist) {
    this._playlist = pPlaylist;

    this._songID = pSnap.documentID;
    this._titel = pSnap['titel'];
    this._artist = pSnap['artist'];
    this._platform = pSnap['platform'];
    this._platformID = pSnap['youtube_id'];
    this._imageURL = pSnap['image_url'];
    this._ranking = double.parse(pSnap['ranking'].toString());
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(pSnap['created_at'].seconds * 1000);
    this._creator = new User.fromFirebase(pSnap['creator']);
    this._downvoteCount = pSnap['downvote_count'];
    this._upvoteCount = pSnap['upvote_count'];
    this._songStatus = SongStatus.fromFirebase(pSnap['song_status']);
  }
  Song.fromLocal(dynamic pItem) {
    this._titel = pItem['titel'];
    this._artist = pItem['artist'];
    this._platform = pItem['platform'];
    this._platformID = pItem['youtube_id'];
    this._imageURL = pItem['image_url'];
    User creator = new User();
    creator.userID = Controller().authentificator.user.userID;
    creator.username = Controller().authentificator.user.username;
    this._creator = creator;
    this._songStatus = new SongStatus();
  }
  Map<String, dynamic> toFirebase() {
    return {
      'titel': this._titel,
      'artist': this._artist,
      'image_url': this._imageURL,
      'platform': this._platform,
      'youtube_id': this._platformID,
      'ranking': 1,
      'created_at': DateTime.now(),
      'upvote_count': 0,
      'downvote_count': 0,
      'creator': this._creator.toFirebase(short: true),
      'song_status': this._songStatus.toFirebase(),
    };
  }

  Map<String, dynamic> toLocal() {
    return {
      'titel': this._titel,
      'artist': this._artist,
      'image_url': this._imageURL,
      'platform': this._platform,
      'youtube_id': this._platformID,
    };
  }

  Future<void> loadURL() async {
    print("-- LOADING URL FOR " + this.titel);
    switch (this._platform) {
      case 'YOUTUBE':
        this._soundURL = await Controller().youTube.getSoundUrlViaPlugin(this._platformID);
        //this._soundURL = await Controller().youTube.getSoundURL(this._platformID);
        break;
      case 'SOUNDCLOUD':
        this._soundURL = await Controller().soundCloud.getSoundURL(this._platformID);
        break;
    }
    print("-- LOADED URL FOR " + this.titel);
    print(this._soundURL);
  }

  Future<void> _updateStatus() async {
    await Controller().firebase.updateSongStatus(this._playlist, this);
  }

  Future<void> play() async {
    this._songStatus.status = 'PLAYING';
    await this._updateStatus();
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

  set duration(int pDuration) {
    this._duration = pDuration;
  }

  set soundURL(String pSoundURL) {
    this._soundURL = pSoundURL;
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

  String get platform {
    return this._platform;
  }

  String get platformID {
    return this._platformID;
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

  int get duration {
    return this._duration;
  }

  User get creator {
    return this._creator;
  }

  SongStatus get songStatus {
    return this._songStatus;
  }
}
