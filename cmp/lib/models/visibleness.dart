class Visibleness {
  String _key;

  Visibleness(this._key);

  String get key {
    return this._key;
  }

  set key(String pKey) {
    switch (pKey) {
      case 'privat':
        this._key = 'PRIVATE';
        break;
      case 'private Playlist':
        this._key = 'PRIVATE';
        break;
      case 'öffentlich':
        this._key = 'PUBLIC';
        break;
      case 'öffentliche Playlist':
        this._key = 'PUBLIC';
        break;
      default:
        this._key = 'error';
        break;
    }
  }

  String get value {
    switch (this._key) {
      case 'PRIVATE':
        return 'privat';
        break;
      case 'PUBLIC':
        return 'öffentlich';
        break;
      default:
        return 'error';
        break;
    }
  }

  String get longValue {
    switch (this._key) {
      case 'PRIVATE':
        return 'private Playlist';
        break;
      case 'PUBLIC':
        return 'öffentliche Playlist';
        break;
      default:
        return 'error';
        break;
    }
  }
}
