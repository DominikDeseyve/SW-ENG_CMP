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
import 'package:cmp/modules/PaginationModule.dart';

class Firebase {
  Controller _controller;
  Firestore _ref;
  Source _source;

  Firebase(Controller pController) {
    this._controller = pController;
    this._ref = Firestore.instance;
    this._source = Source.server;
  }

  static List<String> generateKeywords(List<String> pItems) {
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

  Future<HttpsCallableResult> _callCloudFunction(String pName, Map<String, dynamic> pParams) async {
    CloudFunctions cf = CloudFunctions(region: 'europe-west2');
    HttpsCallableResult response;

    print("CALL CLOUD FUNCTION: " + pName);
    try {
      final HttpsCallable callable = cf.getHttpsCallable(functionName: pName);
      response = await callable.call(pParams);
      return response;
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    return null;
  }

  //***************************************************//
  //*********       USER FUNKTIONEN         ***********//
  //***************************************************//
  // Erstellen
  Future<void> createUser(User pUser, String pEmail) async {
    await this._ref.collection('user').document(pUser.userID).setData({
      'username': pUser.username,
      'email': pEmail,
      'image_url': null,
      'birthday': pUser.birthday,
      'downvotes': [],
      'upvotes': [],
    });
    Settings settings = new Settings();
    await this._ref.collection('settings').document(pUser.userID).setData(settings.toFirebase());
  }

  Future<void> deleteUser() async {
    User user = Controller().authentificator.user;

    await this._callCloudFunction('deleteUser', {
      'user_id': user.userID,
    });
    //TODO
    await this._ref.collection('user').document(user.userID).delete();
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
    //TODO: change song --> creator data
    await this._ref.collection('user').document(pUser.userID).updateData(pUser.toFirebase());
  }

  Future<bool> isUsernameExisting(String pUsername) async {
    return await this._ref.collection('user').where('username', isEqualTo: pUsername).getDocuments(source: this._source).then((QuerySnapshot pQuery) async {
      return (pQuery.documents.length >= 1);
    });
  }

  Future<bool> isEmailExisting(String pEmail) async {
    return await this._ref.collection('user').where('email', isEqualTo: pEmail).getDocuments(source: this._source).then((QuerySnapshot pQuery) async {
      return (pQuery.documents.length >= 1);
    });
  }

  Future<String> convertUsernameToMail(String pUsername) async {
    QuerySnapshot query = await this._ref.collection('user').where('username', isEqualTo: pUsername).limit(1).getDocuments(source: this._source);
    if (query.documents.length == 0) {
      return null;
    } else {
      return query.documents[0]['email'];
    }
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

    DocumentReference ref = await this._ref.collection('playlist').add(
          pPlaylist.toFirebase(),
        );
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

  Future<void> updateSongStatus(Playlist pPlaylist, Song pCurrentSong) async {
    if (pCurrentSong.songStatus.isPast) {
      await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pCurrentSong.songID).delete();
    } else {
      await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('queued_song').document(pCurrentSong.songID).updateData({
        'song_status': pCurrentSong.songStatus.toFirebase(),
      });
    }
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
        pSnap.reference.updateData(pPlaylist.toFirebase(short: true));
      });
    });
    await this._ref.collection('playlist').document(pPlaylist.playlistID).updateData(
          pPlaylist.toFirebase(),
        );
  }

  // Löschen
  Future<void> deletePlaylist(Playlist pPlaylist) async {
    await this._callCloudFunction('deletePlaylist', {
      'playlist_id': pPlaylist.playlistID,
    });
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
      Map<String, dynamic> playlistMap = pPlaylist.toFirebase(short: true);
      Map<String, dynamic> creatorMap;
      if (pPlaylist.creator.userID == pUser.userID) {
        creatorMap = {'is_creator': true};
      } else {
        creatorMap = {'is_creator': false};
      }
      playlistMap..addAll(creatorMap);
      await this._ref.collection('user').document(pUser.userID).collection('joined_playlist').document(pPlaylist.playlistID).setData(playlistMap);
      return true;
    } else {
      return false;
    }
  }

  // Verlassen
  Future<void> leavePlaylist(Playlist pPlaylist, User pUser) async {
    await this._ref.collection('playlist').document(pPlaylist.playlistID).collection('joined_user').document(pUser.userID).delete();
    await this._ref.collection('user').document(pUser.userID).collection('joined_playlist').document(pPlaylist.playlistID).delete();
  }

  // Get (Erstellte Playlists)
  Future<List<Playlist>> getCreatedPlaylist() async {
    List<Playlist> playlists = [];
    String userID = this._controller.authentificator.user.userID;

    return await this._ref.collection('playlist').where('creator.user_id', isEqualTo: userID).limit(10).getDocuments(source: this._source).then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebase(pPlaylist));
      });
      return playlists;
    });
  }

  Future<QuerySnapshot> getAllPlaylists({PaginationModule paginationModule}) async {
    if (paginationModule.lastDocument == null) {
      return this._ref.collection('playlist').orderBy('name').limit(paginationModule.stepSize + 1).getDocuments(source: this._source);
    } else {
      return this._ref.collection('playlist').orderBy('name').startAtDocument(paginationModule.lastDocument).limit(paginationModule.stepSize + 1).getDocuments(source: this._source);
    }
  }

  // Get (Beigetretene Playlists)
  Future<List<Playlist>> getJoinedPlaylist() async {
    List<Playlist> playlists = [];
    User user = Controller().authentificator.user;
    return await this
        ._ref
        .collection('user')
        .document(user.userID)
        .collection('joined_playlist')
        .where('is_creator', isEqualTo: false)
        .limit(10)
        .getDocuments(source: this._source)
        .then((QuerySnapshot pQuery) {
      pQuery.documents.forEach((pPlaylist) {
        playlists.add(Playlist.fromFirebase(pPlaylist, short: true));
      });
      return playlists;
    });
  }

  Future<QuerySnapshot> getPopularPlaylist({PaginationModule paginationModule}) async {
    if (paginationModule == null) {
      return this._ref.collection('playlist').orderBy('joined_user_count', descending: true).orderBy('name').limit(10).getDocuments(source: this._source);
    }
    //if pagination
    if (paginationModule.lastDocument == null) {
      return this._ref.collection('playlist').orderBy('joined_user_count', descending: true).orderBy('name').limit(paginationModule.stepSize + 1).getDocuments(source: this._source);
    } else {
      return this
          ._ref
          .collection('playlist')
          .orderBy('joined_user_count', descending: true)
          .orderBy('name')
          .startAtDocument(paginationModule.lastDocument)
          .limit(paginationModule.stepSize + 1)
          .getDocuments(source: this._source);
    }
  }

  //***************************************************//
  //*********       SONG-FUNKTIONEN         ***********//
  //***************************************************//
  // Erstellen

  Future<void> thumbSong(Playlist pPlaylist, Song pSong, String pDirection) async {
    CloudFunctions cf = CloudFunctions(region: 'europe-west2');
    try {
      final HttpsCallable callable = cf.getHttpsCallable(
        functionName: 'voteSong',
      );
      await callable.call(<String, dynamic>{
        'playlist_id': pPlaylist.playlistID,
        'song_id': pSong.songID,
        'direction': pDirection,
      });
      //print(resp.data);
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e.message);
    }

    String userID = Controller().authentificator.user.userID;
    if (pDirection == 'UP' || pDirection == 'DOWN_UP') {
      await this._ref.collection('user').document(userID).updateData({
        'upvotes': FieldValue.arrayUnion([pSong.songID]),
        'downvotes': FieldValue.arrayRemove([pSong.songID]),
      });
    } else {
      await this._ref.collection('user').document(userID).updateData({
        'upvotes': FieldValue.arrayRemove([pSong.songID]),
        'downvotes': FieldValue.arrayUnion([pSong.songID]),
      });
    }
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
        user.add(User.fromFirebase(pSnap, short: true));
      });
    });
    return user;
  }

  Future<Role> getPlaylistUserRole(String pPlaylistID, User pUser) async {
    return await this._ref.collection('playlist').document(pPlaylistID).collection('joined_user').document(pUser.userID).get(source: this._source).then((DocumentSnapshot pSnap) {
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
      query = this._ref.collection('playlist').document(pPlaylist.playlistID).collection('request').where('user.user_id', isEqualTo: pUser.userID);
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
          .where('song_status.status', whereIn: ['OPEN', 'PLAYING'])
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
          .where('song_status.status', isEqualTo: 'OPEN')
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