class SongStatus {
  bool _isPast;
  bool _isPlaying;
  int _time;

  SongStatus() {
    this._isPast = false;
    this._isPlaying = false;
  }
  SongStatus.fromFirebase(Map pMap) {
    this._isPast = pMap['is_past'];
    this._isPlaying = pMap['is_playing'];
    if (this._isPlaying) {
      this._time = pMap['time'];
    } else {
      this._time = null;
    }
  }

  Map<String, dynamic> toFirebase() {
    if (this._isPlaying) {
      return {
        'is_past': this._isPast,
        'is_playing': true,
        'time': this._time,
      };
    } else {
      return {
        'is_past': this._isPast,
        'is_playing': false,
      };
    }
  }

  void end() {
    this._isPlaying = false;
    this._isPast = true;
  }

  void play() {
    this._isPlaying = true;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get isPlaying {
    return this._isPlaying;
  }

  bool get isPast {
    return this._isPast;
  }
}
