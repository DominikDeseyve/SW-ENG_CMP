import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/genre.dart';
import 'package:cmp/models/playlist.dart';

class Firebase {
  Firestore _ref;
  Source _source;

  Firebase() {
    this._ref = Firestore.instance;
    this._source = Source.serverAndCache;
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
}
