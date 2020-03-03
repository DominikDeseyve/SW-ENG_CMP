import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/logic/Controller.dart';

class Settings {
  bool _darkMode;
  int _crossfade;
  String _language;

  Settings() {
    this._darkMode = false;
    this._crossfade = 0;
    this._language = 'GERMAN';
  }
  Settings.fromFirebase(DocumentSnapshot pSnap) {
    this._darkMode = pSnap['dark_mode'];
    if (_darkMode) {
      Controller().theming.initDark();
    } else {
      Controller().theming.initLight();
    }

    this._crossfade = pSnap['crossfade'];
    //this._language = pSnap['language'];
  }

  Map<String, dynamic> toFirebase() {
    return {
      'dark_mode': this._darkMode,
      'crossfade': this._crossfade,
      'language': this._language,
    };
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get darkMode {
    return this._darkMode;
  }

  set darkMode(bool pDarkMode) {
    this._darkMode = pDarkMode;
  }

  int get crossfade {
    return this._crossfade;
  }

  set crossfade(int pCrossfade) {
    this._crossfade = pCrossfade;
  }
}
