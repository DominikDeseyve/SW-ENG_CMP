import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/logic/Linker.dart';
import 'package:cmp/logic/LocalStorage.dart';
import 'package:cmp/logic/Notification.dart';
import 'package:cmp/logic/SoundCloud.dart';
import 'package:cmp/logic/SoundManager.dart';
import 'package:cmp/logic/Spotify.dart';
import 'package:cmp/logic/Storage.dart';
import 'package:cmp/logic/Theming.dart';
import 'package:cmp/logic/Translater.dart';
import 'package:cmp/logic/YouTube.dart';
import 'package:intl/intl.dart';

enum SoundState {
  PLAYING,
  PAUSED,
  STOPPED,
}

class Controller {
  Linker _linker;
  Authentificator _authentificator;
  LocalStorage _localStorage;
  Firebase _firebase;
  Storage _storage;
  Translater _translater;
  Theming _theming;
  SoundManager _soundManager;
  YouTube _youTube;
  SoundCloud _soundCloud;
  Spotify _spotify;
  Notification _notification;

  static final Controller _controller = Controller._internal();
  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    print("CONSTRUCTOR OF CONTROLLER");
    Intl.defaultLocale = 'de_DE';
    this._linker = new Linker();
    //this._linker.listen();
    this._translater = new Translater();
    this._theming = new Theming();
    this._authentificator = new Authentificator(this);
    this._firebase = new Firebase(this);
    this._storage = new Storage();
    this._soundManager = new SoundManager();
    this._youTube = new YouTube();
    this._soundCloud = new SoundCloud();
    this._spotify = new Spotify();
    this._localStorage = new LocalStorage();
    this._notification = new Notification(this);
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Linker get linker => this._linker;

  Authentificator get authentificator => this._authentificator;

  Firebase get firebase => this._firebase;

  Storage get storage => this._storage;

  Theming get theming => this._theming;

  Translater get translater => this._translater;

  SoundManager get soundManager => this._soundManager;

  YouTube get youTube => this._youTube;

  SoundCloud get soundCloud => this._soundCloud;

  Spotify get spotify => this._spotify;

  LocalStorage get localStorage => this._localStorage;

  Notification get notification => this._notification;
}
