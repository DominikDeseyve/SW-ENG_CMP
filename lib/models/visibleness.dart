class Visibleness {
  final String _key;

  Visibleness(this._key);

  String get key {
    return this._key;
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
        return 'privates Event';
        break;
      case 'PUBLIC':
        return 'öffentliches Event';
        break;
      default:
        return 'error';
        break;
    }
  }
}
