class SongStatus {
  int _time;
  String _status;

  SongStatus() {
    this._status = 'OPEN';
  }
  SongStatus.fromFirebase(Map pMap) {
    this._status = pMap['status'];
    if (this._status == 'PLAYING') {
      this._time = pMap['time'];
    } else {
      this._time = null;
    }
  }

  Map<String, dynamic> toFirebase() {
    if (this._status == 'PLAYING') {
      return {
        'status': 'PLAYING',
        'time': this._time,
      };
    } else {
      return {
        'status': this._status,
      };
    }
  }

  set status(String pStatus) {
    this._status = pStatus;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get isPlaying {
    return (this._status == 'PLAYING');
  }

  bool get isPast {
    return (this._status == 'END');
  }
}
