import 'package:cmp/logic/Authentificator.dart';
import 'package:cmp/logic/Firebase.dart';

class Controller {
  Authentificator _authentificator;
  Firebase _firebase;
  static final Controller _controller = Controller._internal();

  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    print("CONSTRUCTOR OF CONTROLLER");
    this._authentificator = new Authentificator(this);
    this._firebase = new Firebase();
  }

  Future<void> initializeUser() async {}

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Authentificator get authentificator {
    return this._authentificator;
  }

  Firebase get firebase {
    return this._firebase;
  }
}
