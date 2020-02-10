import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';

class Firebase {
  Controller _controller;
  Firestore _ref;
  Source _source;

  Firebase(Controller pController) {
    this._controller = pController;
    this._ref = Firestore.instance;
    this._source = Source.server;
  }

  Future<void> createPlaylist(Playlist pPlaylist) async {
    await this._ref.collection('playlist').add({
      'name': pPlaylist.name,
      'max_attendees': pPlaylist.maxAttendees,
      'visibleness': pPlaylist.visibleness.key,
      'blacked_genre': pPlaylist.blackedGenre,
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

    return await this._ref.collection('playlist').where('creator.uid', isEqualTo: "DFJwbs7m0LMdyOOa7YQIFEvtTB83").getDocuments(source: this._source).then((QuerySnapshot pQuery) {
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
}