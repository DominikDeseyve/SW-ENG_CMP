import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/role.dart';
import 'package:cmp/models/settings.dart';
import 'package:cmp/models/song.dart';
import 'package:cmp/models/user.dart';
import 'package:cmp/widgets/Pagination.dart';

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

  Future<String> createUser(User pUser) async {
    DocumentReference ref = await this._ref.collection('user').add({
      'username': pUser.username,
      'image_url': null,
      'birthday': pUser.birthday,
    });
    return ref.documentID;
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

  Future<void> joinPlaylist(Playlist pPlaylist, User pUser, Role pRole) {
    Map userWithRole = pUser.toFirebase()..addAll(pRole.toFirebase());
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).setData(userWithRole);
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
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).updateData({
      'upvotes': FieldValue.arrayUnion([Controller().authentificator.user.userID]),
      'downvotes': FieldValue.arrayRemove([Controller().authentificator.user.userID]),
    });
  }

  Future<void> thumbDownSong(Playlist pPlaylist, Song pSong) async {
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).updateData({
      'upvotes': FieldValue.arrayRemove([Controller().authentificator.user.userID]),
      'downvotes': FieldValue.arrayUnion([Controller().authentificator.user.userID]),
    });
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

  Stream<QuerySnapshot> getPlaylistQueue(Playlist pPlaylist, PaginationStream pPagination) {
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').orderBy('ranking').snapshots();
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
}
