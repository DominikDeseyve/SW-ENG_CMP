import 'package:cmp/models/language.dart';

class Translater {
  Language _language;

  Translater() {
    this._language = english;
  }

  void switchLanguage(String pLanguageName) {
    switch (pLanguageName) {
      case 'GERMAN':
        this._language = german;
        break;
      default:
    }
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Language get language => this._language;
}
