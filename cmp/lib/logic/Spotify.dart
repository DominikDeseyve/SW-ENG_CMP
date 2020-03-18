import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:io';
import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/song.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart';

class Spotify {
  String _authToken = '';
  DateTime _authExpires;
  String _clientID = 'aa344dbc47ee4c009d9ecba2234026ce';
  String _url = 'https://api.spotify.com/v1/search';
  Timer _timer;

  StreamSubscription _state;
  Spotify() {}

  Future<List<Song>> search(String pQuery) async {
    List<Song> songs = [];

    var queryParameters = {
      'market': 'de',
      'type': 'track',
      'limit': '5',
      'q': pQuery,
    };

    try {
      Uri uri = Uri(path: this._url, queryParameters: queryParameters);
      String url = Uri.decodeFull(uri.toString());
      await this.initAuthentificationToken();
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer " + this._authToken,
      });
      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
        for (var item in json['tracks']['items']) {
          print(item);
          Song song = new Song.fromSpotify(item);
          songs.add(song);
        }
      } else {
        print("-- SPOTIFY -- STATUS CODE ERROR (maybe limit exceeded)");
      }
    } catch (e) {
      print("NETWORK ERROR");
      print(e);
    }
    return songs;
  }

  Future<void> initAuthentificationToken() async {
    if (this._authToken == '' || DateTime.now().difference(this._authExpires).inMinutes >= 59) {
      try {
        String authenticationToken = await SpotifySdk.getAuthenticationToken(
          
          clientId: this._clientID,
          redirectUrl: "https://deseyve.com",
        );
        this._authExpires = DateTime.now();
        this._authToken = authenticationToken;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      bool result = await SpotifySdk.connectToSpotifyRemote(
        clientId: this._clientID,
        redirectUrl: "https://deseyve.com",
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPlayingStatus() async {
    var queryParameters = {
      'market': 'de',
    };

    try {
      Uri uri = Uri(path: 'https://api.spotify.com/v1/me/player/currently-playing', queryParameters: queryParameters);
      String url = Uri.decodeFull(uri.toString());
      await this.initAuthentificationToken();
      var response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer " + this._authToken,
      });
      if (response.statusCode == 200) {
        var json = JSON.jsonDecode(response.body);
      } else {
        print("-- SPOTIFY -- STATUS CODE ERROR (maybe limit exceeded)");
      }
    } catch (e) {
      print("NETWORK ERROR");
      print(e);
    }
  }

  void startListen() {
    this._state = SpotifySdk.subscribePlayerState().listen((PlayerState pState) {
      if (pState.isPaused && pState.playbackPosition == 0) {
        print("SPOTIFY SONG END");
        this._state.cancel();
        Controller().soundManager.nextSong();
      }

      //print(pState.playbackPosition);
      /*if (pState.isPaused) {
        Controller().soundManager.pause();
      } else {
        Controller().soundManager.play();
      }*/
    });
  }

  void dispose() {
    SpotifySdk.logout();
    this._state.cancel();
  }

  //***************************************************//
  //*********   SOUND
  //***************************************************//
  Future<void> play(String pTrackID, SoundState pState) async {
    try {
      if (pState == SoundState.PAUSED) {
        await SpotifySdk.resume();
      } else {
        await SpotifySdk.play(spotifyUri: this._getSpotifyURI(pTrackID));
      }
      this.startListen();
    } catch (e) {
      print(e);
    }
  }

  Future<void> stop() async {
    print("stop spotify");
    try {
      await SpotifySdk.pause();
      //await SpotifySdk.logout();
    } catch (e) {
      print(e);
    }
  }

  Future<void> seek(Duration pPosition) async {
    await SpotifySdk.seekTo(positionedMilliseconds: pPosition.inMilliseconds);
  }

  //***************************************************//
  //*********   CONVERTER
  //***************************************************//

  String _getSpotifyURI(String pID) {
    return "spotify:track:" + pID;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Future<PlayerState> getState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } catch (e) {
      print(e);
    }
  }
}
