import 'dart:io';
import 'dart:convert' as JSON;
import 'package:cmp/models/song.dart';
import 'package:http/http.dart' as http;

class SoundCloud {
  String _url;
  String _clientID;

  SoundCloud() {
    this._url = "https://api.soundcloud.com/tracks";
    this._clientID = 'oSGk2QGxkm3FzfZxx3SXThrXN2qPpL3M';
  }

  Future<List<Song>> search(String pQuery) async {
    List<Song> songs = [];

    var queryParameters = {
      'client_id': this._clientID,
      'q': Uri.encodeFull(pQuery),
    };
    Uri uri = Uri(path: this._url, queryParameters: queryParameters);
    String url = Uri.decodeFull(uri.toString());
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      var json = JSON.jsonDecode(response.body);
      for (var item in json) {
        Song song = new Song.fromSoundCloud(item);
        songs.add(song);
      }
    }
    return songs;
  }

  Future<String> getSoundURL(String pSoundID) async {
    String urlstart = 'https://api-v2.soundcloud.com/tracks/';
    var queryParameters = {
      'client_id': 'oSGk2QGxkm3FzfZxx3SXThrXN2qPpL3M',
    };
    Uri uri = Uri(path: urlstart + pSoundID, queryParameters: queryParameters);
    String url = Uri.decodeFull(uri.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      var json = JSON.jsonDecode(response.body);

      urlstart = json['media']['transcodings'][1]['url'];
    }

    //second
    uri = Uri(path: urlstart, queryParameters: queryParameters);
    url = Uri.decodeFull(uri.toString());

    response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      var json = JSON.jsonDecode(response.body);
      return json['url'];
    } else {
      return "ERROR";
    }
  }
}
