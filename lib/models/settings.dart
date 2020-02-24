import 'package:cloud_firestore/cloud_firestore.dart';

class Settings {
  bool _darkMode;

  Settings.fromFirebase(DocumentSnapshot pSnap) {
    this._darkMode = pSnap['dark_mode'];
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get darkMode {
    return this._darkMode;
  }
  
}
