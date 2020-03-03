import 'dart:io';

import 'package:cmp/models/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class YouTube {
  static String _key = 'AIzaSyDBPz81OJwsDN5EgcSo-L3gGwt2zdw2ix8';
  //static String _key = 'AIzaSyC3VdXymAHtvfsrkf3wgBauGdCbCY4VqVY';

  String _searchType;
  String _url;

  YouTube() {
    this._url = 'https://www.googleapis.com/youtube/v3/search';
    _searchType = "video";
    //https://developers.google.com/youtube/v3/docs/search/list
  }

  Future<List<Song>> search(String pQuery) async {
    List<Song> songs = [];

    var queryParameters = {
      'part': 'snippet',
      'type': this._searchType,
      'maxResults': '5',
      'key': _key,
      'q': pQuery,
    };

    try {
      Uri uri = Uri(path: this._url, queryParameters: queryParameters);
      String url = Uri.decodeFull(uri.toString());

      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        print(response.body);
        var json = JSON.jsonDecode(response.body);
        for (var item in json['items']) {
          Song song = new Song.fromYoutube(item);
          songs.add(song);
        }
      }
    } catch (e) {
      print("NETWORK ERROR");
      print(e);
    }

    return songs;
  }
}
