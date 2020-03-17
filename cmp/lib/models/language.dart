class Language {
  Map<String, String> _languagePack;

  Language(Map<String, String> pNames) {
    _languagePack = pNames;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  Map<String, String> get languagePack => this._languagePack;

  String getLanguagePack(String pName) => this._languagePack[pName];
}
