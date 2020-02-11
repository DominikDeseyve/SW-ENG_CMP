import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Firebase.dart';
import 'package:cmp/logic/Storage.dart';
import 'package:cmp/logic/Theming.dart';

class Controller {
  Authentificator _authentificator;
  Firebase _firebase;
  Storage _storage;
  Theming _theming;
  static final Controller _controller = Controller._internal();

  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    print("CONSTRUCTOR OF CONTROLLER");
    this._authentificator = new Authentificator(this);
    this._firebase = new Firebase(this);
    this._storage = new Storage();
    this._theming = new Theming();
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
}
