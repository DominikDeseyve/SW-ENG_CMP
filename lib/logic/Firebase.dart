import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/settings.dart';
import 'package:cmp/models/user.dart';

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

  Future<String> createPlaylist(Playlist pPlaylist) async {
    DocumentReference ref = await this._ref.collection('playlist').add({
      'name': pPlaylist.name,
      'image_url': pPlaylist.imageURL,
      'max_attendees': pPlaylist.maxAttendees,
      'visibleness': pPlaylist.visibleness.key,
      'blacked_genre': pPlaylist.blackedGenre.map((genre) => genre.toFirebase()).toList(),
      'creator': pPlaylist.creator.toFirebase(),
      'keywords:': this._generateKeywords([pPlaylist.name]),
      'user_count': 0
    });
    return ref.documentID;
  }

  Future<void> joinPlaylist(Playlist pPlaylist, User pUser) {
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).setData(
          pUser.toFirebase(),
        );
  }

  Future<void> updatePlaylist(Playlist pPlaylist) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).updateData({
      'name': pPlaylist.name,
      'image_url': pPlaylist.imageURL,
      'max_attendees': pPlaylist.maxAttendees,
      'visibleness': pPlaylist.visibleness.key,
      'blacked_genre': pPlaylist.blackedGenre.map((genre) => genre.toFirebase()).toList(),
      'creator': pPlaylist.creator.toFirebase(),
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

  Stream<QuerySnapshot> getPlaylistQueue(String pPlaylistID) {
    return this._ref.collection(pPlaylistID).document(pPlaylistID).collection('queued_song').snapshots();
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
