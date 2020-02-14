import 'package:youtube_api/youtube_api.dart';

class YouTube {
  static String _key = 'YOUR_API_KEY';
  YoutubeAPI _youtubeAPI;

  YouTube() {
    this._youtubeAPI = new YoutubeAPI(_key);
  }

  void search(String pQuery) async {
    await this._youtubeAPI.search(pQuery);
  }
}
