import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/logic/LocalStorage.dart';
import 'package:cmp/logic/SoundPlayer.dart';
import 'package:cmp/logic/Storage.dart';
import 'package:cmp/logic/Theming.dart';
import 'package:cmp/logic/YouTube.dart';
import 'package:intl/intl.dart';

class Controller {
  Authentificator _authentificator;
  LocalStorage _localStorage;
  Firebase _firebase;
  Storage _storage;
  Theming _theming;
  SoundPlayer _soundPlayer;
  YouTube _youTube;

  static final Controller _controller = Controller._internal();
  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    print("CONSTRUCTOR OF CONTROLLER");
    Intl.defaultLocale = 'de_DE';

    this._theming = new Theming();
    this._authentificator = new Authentificator(this);
    this._firebase = new Firebase(this);
    this._storage = new Storage();
    this._soundPlayer = new SoundPlayer();
    this._youTube = new YouTube();
    this._localStorage = new LocalStorage();
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Authentificator get authentificator {
    return this._authentificator;
  }

  Firebase get firebase {
    return this._firebase;
  }

  Storage get storage {
    return this._storage;
  }

  Theming get theming {
    return this._theming;
  }

  SoundPlayer get soundPlayer {
    return this._soundPlayer;
  }

  YouTube get youTube {
    return this._youTube;
  }

  LocalStorage get localStorage {
    return this._localStorage;
  }
}
