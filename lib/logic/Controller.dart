import 'package:cmp/logic/Authentificator.dart';

class Controller {
  Authentificator _authentificator;
  static final Controller _controller = Controller._internal();

  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    print("CONSTRUCTOR OF CONTROLLER");
    this._authentificator = new Authentificator(this);
  }

  Future<void> initializeUser() async {}

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Authentificator get authentificator {
    return this._authentificator;
  }
}
