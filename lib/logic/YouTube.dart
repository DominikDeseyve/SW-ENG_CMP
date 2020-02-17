import 'package:cmp/models/song.dart';
import 'package:youtube_api/youtube_api.dart';

class YouTube {
  static String _key = 'AIzaSyDBPz81OJwsDN5EgcSo-L3gGwt2zdw2ix8';
  YoutubeAPI _youtubeAPI;

  YouTube() {
    int max = 25;
    String type = "channel";
    this._youtubeAPI = new YoutubeAPI(_key, maxResults: max, type: type);
  }

  Future<List<Song>> search(String pQuery) async {
    List<YT_API> results = await this._youtubeAPI.search(pQuery);
    List<Song> songs = [];
    results.forEach((YT_API item) async {
      Song song = new Song.fromYoutube(item);
      songs.add(song);
    });
    return songs;
  }
}
