class Language {
  String _appName = 'Connected-Music-Player';
  String _joinedPlaylists;

  Language(Map<String, dynamic> pNames) {
    this._joinedPlaylists = pNames['joined_playlists'];
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get appName => this._appName;
  String get joinedPlaylists => this._joinedPlaylists;
}

Language german = new Language({
  'joined_playlists': 'Meine Playlists',
});

Language english = new Language({
  'joined_playlists': 'Joined Playlists',
});
