import 'dart:async';
import 'package:cmp/logic/Controller.dart';

class CrossfadeTimer {
  Timer _timer;
  int _tick;
  Function(int) _callback;
  bool _isActivated;

  CrossfadeTimer(Function(int) pCallback) {
    this._isActivated = false;
    this._callback = pCallback;
  }

  void _run() {
    this._timer = Timer.periodic(Duration(seconds: 1), (timer) {
      this._tick--;
      if (this._tick <= 0) {
        this.stop();
      }
      this._callback(this._tick);
    });
  }

  void start() {
    print("-- CROSSFADE TIMER -- START");
    this._tick = Controller().authentificator.user.settings.crossfade;
    this._isActivated = true;
    this._run();
  }

  void pause() {
    if (this._isActivated) {
      print("-- CROSSFADE TIMER -- PAUSE");
      this._timer.cancel();
    }
  }

  void resume() {
    if (this._isActivated && !this._timer.isActive) {
      print("-- CROSSFADE TIMER -- RESUME");
      this._run();
    }
  }

  void stop() {
    if (this._timer != null) {
      this._isActivated = false;
      this._timer.cancel();
    }
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get isActivated {
    return this._isActivated;
  }
}
