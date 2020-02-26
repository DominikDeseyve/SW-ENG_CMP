import 'package:cmp/models/playlist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class LocalStorage {
  StoreRef _storeRef;
  Database _database;

  List<String> _searchedPlaylists = [];

  LocalStorage() {
    _storeRef = StoreRef.main();
    this._init();
  }

  void _init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'my_database.db');
    this._database = await databaseFactoryIo.openDatabase(dbPath);

    this._fetchValues();
  }

  Future<void> pushPlaylistSearch(Playlist pPlaylist) async {
    if (this._searchedPlaylists.length >= 5) {
      this._searchedPlaylists.removeAt(0);
    }
    if (this._searchedPlaylists.contains((item) => item == pPlaylist.playlistID)) {
      return;
    }
    _searchedPlaylists.add(pPlaylist.playlistID);
    await _storeRef.record('searched_playlist').put(_database, _searchedPlaylists);
  }

  void resetSearchPlaylist() async {
    this._searchedPlaylists.clear();
    await _storeRef.record('searched_playlist').put(_database, _searchedPlaylists);
  }

  void _fetchValues() async {
    var r = await this._storeRef.record('searched_playlist').get(this._database);
    this._searchedPlaylists = List.from(r);
  }

  List<String> get searchedPlaylists {
    return this._searchedPlaylists;
  }

  void dispose() {
    this._database.close();
  }
}
