import 'package:cmp/models/language.dart';

class Translater {
  Language _language;

  Translater() {
    //default language
    this._language = german;
  }

  void switchLanguage(String pLanguageName) {
    switch (pLanguageName) {
      case 'GERMAN':
        this._language = german;
        break;
      case 'ENGLISH':
        this._language = english;
        break;
      default:
    }
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Language get language => this._language;
}
