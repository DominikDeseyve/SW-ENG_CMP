import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  //***************************************************//
  //*********       USER FUNKTIONEN         ***********//
  //***************************************************//
  // Erstellen
  Future<void> createUser(User pUser) async {
    await this._ref.collection('user').document(pUser.userID).setData({
      'username': pUser.username,
      'image_url': null,
      'birthday': pUser.birthday,
      'downvotes': [],
      'upvotes': [],
    });
    Settings settings = new Settings();
    await this._ref.collection('settings').document(pUser.userID).setData(settings.toFirebase());
  }

  // Bearbeiten
  Future<void> updateUserData(User pUser) async {
    await this._ref.collection('playlist').where('creator.user_id', isEqualTo: pUser.userID).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        pSnap.reference.updateData({
          'creator': pUser.toFirebase(),
        });
      });
    });
    await this._ref.collectionGroup('request').where('user.user_id', isEqualTo: pUser.userID).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        pSnap.reference.updateData({
          'user': pUser.toFirebase(),
        });
      });
    });
    await this._ref.collectionGroup('joined_user').where('user_id', isEqualTo: pUser.userID).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        pSnap.reference.updateData(pUser.toFirebase());
      });
    });
    await this._ref.collection('user').document(pUser.userID).updateData(pUser.toFirebase());
  }

  Future<void> updateRole(Playlist pPlaylist, User pUser) async {
    if (pUser.role.isMaster) {
      QuerySnapshot query = await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').where('role.is_master', isEqualTo: true).getDocuments(source: this._source);
      await Future.forEach(query.documents, (DocumentSnapshot pSnap) {
        Role role = new Role.fromFirebase(pSnap['role']);
        role.isMaster = false;
        pSnap.reference.updateData(role.toFirebase());
      });
    }

    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).updateData(
          pUser.role.toFirebase(),
        );
  }

  // Get
  Future<User> getUser(String pUserID) async {
    return await this._ref.collection('user').document(pUserID).get(source: this._source).then((DocumentSnapshot pSnapshot) {
      if (!pSnapshot.exists) return null;
      return User.fromFirebase(pSnapshot);
    });
  }

  // Löschen

  // User-Joins
  Future<bool> isUserJoiningPlaylist(String pPlaylistID, User pUser) async {
    DocumentSnapshot ref = await this._ref.collection('playlist').document(pPlaylistID).collection('joined_user').document(pUser.userID).get(source: this._source);
    return ref.exists;
  }

  //***************************************************//
  //*********       PLAYLIST-FUNKTIONEN     ***********//
  //***************************************************//
  // Erstellen
  Future<String> createPlaylist(Playlist pPlaylist) async {
    if (pPlaylist.description == null) {
      pPlaylist.description = " ";
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
      'created_at': DateTime.now(),
    });
    return ref.documentID;
  }

  // Erstelle Song
  Future<void> createSong(Playlist pPlaylist, Song pSong) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').add(pSong.toFirebase());
  }

  // Lösche Song
  Future<void> deleteSong(Playlist pPlaylist, Song pSong) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).delete();
  }

  Future<void> updateSong(Playlist pPlaylist, Song pCurrentSong) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pCurrentSong.songID).updateData(
          pCurrentSong.toFirebase(),
        );
  }

  Future<List<Playlist>> searchPlaylist(String pKeyword) async {
    List<Playlist> playlists = [];
    pKeyword = pKeyword.toLowerCase();
    return this._ref.collection('playlist').where('keywords', arrayContains: pKeyword).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        playlists.add(Playlist.fromFirebase(pSnap));
      });
      return playlists;
    });
  }

  // Bearbeiten
  Future<void> updatePlaylist(Playlist pPlaylist) async {
    await this._ref.collectionGroup('joined_playlist').where('playlist_id', isEqualTo: pPlaylist.playlistID).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        pSnap.reference.updateData(pPlaylist.toFirebaseShort());
      });
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).updateData({
      'name': pPlaylist.name,
      'image_url': pPlaylist.imageURL,
      'max_attendees': pPlaylist.maxAttendees,
      'description': pPlaylist.description,
      'keywords': this._generateKeywords([pPlaylist.name]),
      'visibleness': pPlaylist.visibleness.key,
      //'blacked_genre': pPlaylist.blackedGenre.map((genre) => genre.toFirebase()).toList(),
      'creator': pPlaylist.creator.toFirebase(),
    });
  }

  // Löschen
  Future<void> deletePlaylist(Playlist pPlaylist) async {
    CloudFunctions cf = CloudFunctions(region: 'us-central1');
    try {
      final HttpsCallable callable = cf.getHttpsCallable(
        functionName: 'recursiveDelete',
      );
      HttpsCallableResult resp = await callable.call(<String, dynamic>{
        'playlist_id': pPlaylist.playlistID,
      });
      print("RESULT:" + resp.data);
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }

    //return this._ref.collection('playlist').document(pPlaylist.playlistID).delete();
  }

  // Request
  Future<void> requestPlaylist(Playlist pPlaylist, Request pRequest) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').document(pRequest.user.userID).setData(pRequest.toFirebase());
  }

  // Beitreten
  Future<bool> joinPlaylist(Playlist pPlaylist, User pUser, Role pRole) async {
    Map userWithRole = pUser.toFirebase()..addAll(pRole.toFirebase());

    DocumentSnapshot playlistSnap = await this._ref.collection('playlist').document(pPlaylist.playlistID).get(source: this._source);
    if (playlistSnap['joined_user_count'] < playlistSnap['max_attendees']) {
      await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).setData(userWithRole);
      await this._ref.collection('user').document(pUser.userID).collection('joined_playlist').document(pPlaylist.playlistID).setData(pPlaylist.toFirebaseShort());
      return true;
    } else {
      return false;
    }
  }

  // Verlassen
  Future<void> leavePlaylist(Playlist pPlaylist, User pUser) {
    return this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).delete();
  }

  // Get (Erstellte Playlists)
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

  // Get (Beigetretene Playlists)
  Future<List<Playlist>> getJoinedPlaylist() async {
    List<Playlist> playlists = [];
    User user = Controller().authentificator.user;
    return await this._ref.collection('user').document(user.userID).collection('joined_playlist').getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebaseShort(pPlaylist));
      });
      return playlists;
    });
  }

  Future<List<Playlist>> getPopularPlaylist() async {
    List<Playlist> playlists = [];

    return await this._ref.collection('playlist').orderBy('joined_user_count', descending: true).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebase(pPlaylist));
      });
      return playlists;
    });
  }

  //***************************************************//
  //*********       SONG-FUNKTIONEN         ***********//
  //***************************************************//
  // Erstellen

  // Like
  Future<void> thumbUpSong(Playlist pPlaylist, Song pSong) async {
    String userID = Controller().authentificator.user.userID;
    await this._ref.collection('user').document(userID).updateData({
      'upvotes': FieldValue.arrayUnion([pSong.songID]),
      'downvotes': FieldValue.arrayRemove([pSong.songID]),
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('DOWN_' + userID).delete();
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('UP_' + userID).setData({});
  }

  // Dislike
  Future<void> thumbDownSong(Playlist pPlaylist, Song pSong) async {
    String userID = Controller().authentificator.user.userID;
    await this._ref.collection('user').document(userID).updateData({
      'downvotes': FieldValue.arrayUnion([pSong.songID]),
      'upvotes': FieldValue.arrayRemove([pSong.songID]),
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('UP_' + userID).delete();
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pSong.songID).collection('votes').document('DOWN_' + userID).setData({});
  }

  //***************************************************//
  //*********       PLAYLIST DETAIL         ***********//
  //***************************************************//
  // Playlist-User
  Future<List<User>> getPlaylistUser(Playlist pPlaylist) async {
    List<User> user = [];
    await this
        ._ref
        .collection('playlist')
        .document(pPlaylist.playlistID)
        .collection('joined_user')
        .orderBy('role.priority', descending: true)
        .getDocuments(source: this._source)
        .then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        user.add(User.fromFirebase(pSnap));
      });
    });
    return user;
  }

  Future<Role> getPlaylistUserRole(Playlist pPlaylist, User pUser) async {
    return await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).get(source: this._source).then((DocumentSnapshot pSnap) {
      if (!pSnap.exists) return Role(ROLE.MEMBER, false);
      return Role.fromFirebase(pSnap['role']);
    });
  }

  // Playlist-Requests
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

  // Playlist-Details
  Future<Playlist> getPlaylistDetails(String pPlaylistID) async {
    return await this._ref.collection('playlist').document(pPlaylistID).get(source: this._source).then((pSnap) {
      if (!pSnap.exists) return null;
      return Playlist.fromFirebase(pSnap);
    });
  }

  // Playlist-Queue
  Stream<QuerySnapshot> getPlaylistQueue(Playlist pPlaylist, Queue pQueue) {
    if (pQueue.lastDocument == null) {
      return this
          ._ref
          .collection('playlist')
          .document(pPlaylist.playlistID)
          .collection('queued_song')
          .where('song_status.is_past', isEqualTo: false)
          .orderBy('ranking', descending: true)
          .orderBy('created_at')
          .limit(pQueue.stepSize)
          .snapshots();
    } else {
      return this
          ._ref
          .collection('playlist')
          .document(pPlaylist.playlistID)
          .collection('queued_song')
          .where('song_status.is_past', isEqualTo: false)
          .orderBy('ranking', descending: true)
          .orderBy('created_at')
          .startAfterDocument(pQueue.lastDocument)
          .limit(pQueue.stepSize)
          .snapshots();
    }
  }

  // Bearbeite Request
  Future<void> updateRequest(Playlist pPlaylist, Request pRequest) async {
    if (pRequest.status == 'ACCEPT') {
      await this.joinPlaylist(pPlaylist, pRequest.user, Role(ROLE.MEMBER, false));
    }
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').document(pRequest.requestID).updateData(pRequest.toFirebase());
  }

  //***************************************************//
  //*********          SONSTIGES            ***********//
  //***************************************************//
  // Get-Genres
  Future<List<Genre>> getGenres() async {
    List<Genre> genres = [];
    return await this._ref.collection('genre').getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pGenre) {
        genres.add(Genre.fromFirebase(pGenre));
      });
      return genres;
    });
  }

  // Get-Settings
  Future<Settings> getSettings(String pUserID) async {
    return await this._ref.collection('settings').document(pUserID).get(source: this._source).then((DocumentSnapshot pSnapshot) {
      if (!pSnapshot.exists) return null;
      return Settings.fromFirebase(pSnapshot);
    });
  }

  Future<void> updateSettings() async {
    User user = Controller().authentificator.user;
    Settings settings = Controller().authentificator.user.settings;
    await this._ref.collection('settings').document(user.userID).updateData(settings.toFirebase());
  }
}
