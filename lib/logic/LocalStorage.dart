import 'package:cmp/models/playlist.dart';
import 'package:cmp/models/song.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class LocalStorage {
  StoreRef _storeRef;
  Database _database;

  List<String> _searchedPlaylists = [];
  List<Song> _searchedSongs = [];

  LocalStorage() {
    _storeRef = StoreRef.main();
    this._init();
  }

  void _init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'my_database.db');
    this._database = await databaseFactoryIo.openDatabase(dbPath);
  }

  void fetchValues() async {
    try {
      var searchedPlaylists = await this._storeRef.record('searched_playlist').get(this._database);
      this._searchedPlaylists = List.from(searchedPlaylists);

      var searchedSongs = await this._storeRef.record('searched_songs').get(this._database);
      List jsonList = List.from(searchedSongs);

      jsonList.forEach((dynamic item) {
        this._searchedSongs.add(Song.fromLocal(item));
      });
    } catch (e) {
      print(e);
    }
  }

  //PLAYLISTS
  Future<void> pushPlaylistSearch(Playlist pPlaylist) async {
    if (this._searchedPlaylists.length >= 5) {
      this._searchedPlaylists.removeAt(0);
    }
    int index = this._searchedPlaylists.indexWhere((item) => item == pPlaylist.playlistID);
    if (index > -1) {
      return;
    }
    this._searchedPlaylists.add(pPlaylist.playlistID);
    await _storeRef.record('searched_playlist').put(_database, _searchedPlaylists);
  }

  void resetSearchPlaylist() async {
    this._searchedPlaylists.clear();
    await _storeRef.record('searched_playlist').put(_database, _searchedPlaylists);
  }

  //SONGS
  Future<void> pushSong(Song pSong) async {
    if (this._searchedSongs.length >= 10) {
      this._searchedSongs.removeAt(0);
    }

    int index = this._searchedSongs.indexWhere((Song item) => (item.platform + '_ ' + item.platformID) == (pSong.platform + '_ ' + pSong.platformID));
    if (index > -1) {
      return;
    }
    this._searchedSongs.add(pSong);
    List<Map<String, dynamic>> songs = [];
    this._searchedSongs.forEach((Song pSong) {
      songs.add(pSong.toLocal());
    });
    await _storeRef.record('searched_songs').put(_database, songs);
  }

  void resetSearchSongs() async {
    this._searchedSongs.clear();
    await _storeRef.record('searched_songs').put(_database, []);
  }

  void dispose() {
    this._database.close();
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  List<String> get searchedPlaylists {
    return this._searchedPlaylists;
  }

  List<Song> get searchedSongs {
    return this._searchedSongs;
  }
}
