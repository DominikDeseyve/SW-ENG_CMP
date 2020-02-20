import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Request.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/settings.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/logic/Queue.dart';

class Firebase {
  Controller _controller;
  Firestore _ref;
  Source _source;

  Firebase(Controller pController) {
    this._controller = pController;
    this._ref = Firestore.instance;
    this._source = Source.server;
  }

  List<String> _generateKeywords(List<String> pItems) {
    List<String> keywordList = [];
    pItems = pItems.toSet().toList(); //delete duplicates
    pItems.forEach((String pItem) {
      String keyword = '';
      pItem.toLowerCase().split('').forEach((String pLetter) {
        keyword += pLetter;
        keywordList.add(keyword);
      });
    });
    return keywordList;
  }

  Future<void> createUser(User pUser) async {
    await this._ref.collection('user').document(pUser.userID).setData({
      'username': pUser.username,
      'image_url': null,
      'birthday': pUser.birthday,
      'downvotes': [],
      'upvotes': [],
    });
  }

  Future<String> createPlaylist(Playlist pPlaylist) async {
    if (pPlaylist.description == null) {
      pPlaylist.description = "test";
    }

    DocumentReference ref = await this._ref.collection('playlist').add({
      'name': pPlaylist.name,
      'image_url': pPlaylist.imageURL,
      'max_attendees': pPlaylist.maxAttendees,
      'description': pPlaylist.description,
      'visibleness': pPlaylist.visibleness.key,
      'blacked_genre': pPlaylist.blackedGenre.map((genre) => genre.toFirebase()).toList(),
      'creator': pPlaylist.creator.toFirebase(),
      'keywords': this._generateKeywords([pPlaylist.name]),
      'joined_user_count': 0,
      'queued_song_count': 0,
    });
    return ref.documentID;
  }

  Future<void> createSong(Playlist pPlaylist, Song pSong) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').add(pSong.toFirebase());
  }

  Future<void> deleteSong(Playlist pPlaylist, Song pSong) async {
    //TODO: remove whole song data
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).delete();
  }

  Future<void> requestPlaylist(Playlist pPlaylist, Request pRequest) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').document(pRequest.user.userID).setData(pRequest.toFirebase());
  }

  Future<void> joinPlaylist(Playlist pPlaylist, User pUser, Role pRole) {
    Map userWithRole = pUser.toFirebase()..addAll(pRole.toFirebase());
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).setData(userWithRole);
  }

  Future<void> leavePlaylist(Playlist pPlaylist, User pUser) {
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).delete();
  }

  Future<void> updateUserData(User pUser) async {
    await this._ref.collection('user_requested_playlist').document(pUser.userID).updateData({
      'user': pUser.toFirebase(),
    });
    await this._ref.collection('user').document(pUser.userID).updateData(pUser.toFirebase());
  }

  Future<void> updatePlaylist(Playlist pPlaylist) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).updateData({
      'name': pPlaylist.name,
      'image_url': pPlaylist.imageURL,
      'max_attendees': pPlaylist.maxAttendees,
      'description': pPlaylist.description,
      'visibleness': pPlaylist.visibleness.key,
      //'blacked_genre': pPlaylist.blackedGenre.map((genre) => genre.toFirebase()).toList(),
      'creator': pPlaylist.creator.toFirebase(),
    });
  }

  Future<void> thumbUpSong(Playlist pPlaylist, Song pSong) async {
    String userID = Controller().authentificator.user.userID;
    await this._ref.collection('user').document(userID).updateData({
      'upvotes': FieldValue.arrayUnion([pSong.songID]),
      'downvotes': FieldValue.arrayRemove([pSong.songID]),
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('DOWN_' + userID).delete();
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('UP_' + userID).setData({});
  }

  Future<void> thumbDownSong(Playlist pPlaylist, Song pSong) async {
    String userID = Controller().authentificator.user.userID;
    await this._ref.collection('user').document(userID).updateData({
      'downvotes': FieldValue.arrayUnion([pSong.songID]),
      'upvotes': FieldValue.arrayRemove([pSong.songID]),
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('UP_' + userID).delete();
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('DOWN_' + userID).setData({});
  }

  Future<List<Genre>> getGenres() async {
    List<Genre> genres = [];
    return await this._ref.collection('genre').getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pGenre) {
        genres.add(Genre.fromFirebase(pGenre));
      });
      return genres;
    });
  }

  Future<List<Playlist>> getCreatedPlaylist() async {
    List<Playlist> playlists = [];
    String userID = this._controller.authentificator.user.userID;

    return await this._ref.collection('playlist').where('creator.user_id', isEqualTo: userID).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebase(pPlaylist));
      });
      return playlists;
    });
  }

  Future<List<Playlist>> getJoinedPlaylist() async {
    List<Playlist> playlists = [];

    return await this._ref.collection('playlist').getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebase(pPlaylist));
      });
      return playlists;
    });
  }

  Future<bool> isUserJoiningPlaylist(Playlist pPlaylist, User pUser) async {
    DocumentSnapshot ref = await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).get(source: this._source);
    return ref.exists;
  }

  Future<Playlist> getPlaylistDetails(Playlist pPlaylist) async {
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).get(source: this._source).then((pSnap) {
      return Playlist.fromFirebase(pSnap);
    });
  }

  Stream<QuerySnapshot> getPlaylistQueue(Playlist pPlaylist, Queue pQueue) {
    if (pQueue.lastDocument == null) {
      return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').orderBy('ranking', descending: true).orderBy('created_at').limit(pQueue.stepSize).snapshots();
    } else {
      return this
          ._ref
          .collection('playlist')
          .document(pPlaylist.playlistID)
          .collection('queued_song')
          .orderBy('ranking', descending: true)
          .orderBy('created_at')
          .startAfterDocument(pQueue.lastDocument)
          .limit(pQueue.stepSize)
          .snapshots();
    }
  }

  Future<User> getUser(String pUserID) async {
    return await this._ref.collection('user').document(pUserID).get(source: this._source).then((DocumentSnapshot pSnapshot) {
      if (!pSnapshot.exists) return null;
      return User.fromFirebase(pSnapshot);
    });
  }

  Future<Settings> getSettings(String pUserID) async {
    return await this._ref.collection('settings').document(pUserID).get(source: this._source).then((DocumentSnapshot pSnapshot) {
      if (!pSnapshot.exists) return null;
      return Settings.fromFirebase(pSnapshot);
    });
  }

  //***************************************************//
  //*********   PLAYLIST DETAIL
  //***************************************************//

  Future<List<User>> getPlaylistUser(Playlist pPlaylist) async {
    List<User> user = [];
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        user.add(User.fromFirebase(pSnap));
      });
    });
    return user;
  }

  Future<List<Request>> getPlaylistRequests(Playlist pPlaylist, {User pUser}) async {
    List<Request> requests = [];
    Query query;
    if (pUser == null) {
      query = this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').where('status', isEqualTo: 'OPEN');
    } else {
      query = this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').where('status', isEqualTo: 'OPEN').where('user.user_id', isEqualTo: pUser.userID);
    }
    await query.getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        requests.add(Request.fromFirebase(pSnap));
      });
    });
    return requests;
  }

  Future<void> updateRequest(Playlist pPlaylist, Request pRequest) async {
    if (pRequest.status == 'ACCEPT') {
      await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pRequest.user.userID).setData(pRequest.user.toFirebase());
    }
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').document(pRequest.requestID).updateData(pRequest.toFirebase());
  }
}
