import 'package:cmp/models/song.dart';
import 'package:youtube_api/youtube_api.dart';

class YouTube {
  //static String _key = 'AIzaSyDBPz81OJwsDN5EgcSo-L3gGwt2zdw2ix8';
  static String _key = 'AIzaSyC3VdXymAHtvfsrkf3wgBauGdCbCY4VqVY';
  YoutubeAPI _youtubeAPI;

  String _searchType;

  YouTube() {
    int max = 5;
    _searchType = "video";
    this._youtubeAPI = new YoutubeAPI(_key, maxResults: max, type: _searchType);
  }

  Future<List<Song>> search(String pQuery) async {
    List<YT_API> results = await this._youtubeAPI.search(pQuery, type: _searchType);
    List<Song> songs = [];
    results.forEach((YT_API item) async {
      Song song = new Song.fromYoutube(item);
      songs.add(song);
    });

    return songs;
  }
}
