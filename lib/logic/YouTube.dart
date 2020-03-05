import 'dart:io';
import 'package:cmp/models/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTube {
  static String _key = 'AIzaSyDBPz81OJwsDN5EgcSo-L3gGwt2zdw2ix8';
  //static String _key = 'AIzaSyC3VdXymAHtvfsrkf3wgBauGdCbCY4VqVY';

  String _url;
  YoutubeExplode _youtubeExplode;

  YouTube() {
    this._youtubeExplode = new YoutubeExplode();
    this._url = 'https://www.googleapis.com/youtube/v3/search';
  }

  Future<List<Song>> search(String pQuery) async {
    List<Song> songs = [];

    var queryParameters = {
      'part': 'snippet',
      'type': 'video',
      'maxResults': '5',
      'key': _key,
      'q': pQuery,
    };

    try {
      Uri uri = Uri(path: this._url, queryParameters: queryParameters);
      String url = Uri.decodeFull(uri.toString());
      print(url);
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
        for (var item in json['items']) {
          Song song = new Song.fromYoutube(item);
          songs.add(song);
        }
      } else {
        print("-- YOUTUBE -- STATUS CODE ERROR (maybe limit exceeded)");
      }
    } catch (e) {
      print("NETWORK ERROR");
      print(e);
    }
    return songs;
  }

  Future<String> getSoundUrlViaPlugin(String pVideoID) async {
    MediaStreamInfoSet mediaStreams = await this._youtubeExplode.getVideoMediaStream(pVideoID);
    AudioStreamInfo a = mediaStreams.audio[0];
    return a.url.toString();
  }

  Future<String> getSoundURL(String pVideoID) async {
    String url = 'https://cmp02.herokuapp.com/api/info?url=https://www.youtube.com/watch?v=' + pVideoID + '&flatten=true';
    //url = 'http://youtube.com/get_video_info?video_id=RLWcYADoV84';
    try {
      var response = await http.get(
        Uri.encodeFull(url),
        headers: {
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
        //return json['videos'][0]['url'].toString();
        return json['videos'][0]['formats'][0]['url'];
      }
    } catch (e) {
      print("NETWORK ERROR");
    }
    return '';
  }
}
