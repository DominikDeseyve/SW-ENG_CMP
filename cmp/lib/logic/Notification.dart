import 'package:cmp/logic/Controller.dart';
import 'package:flutter/material.dart';
import 'package:cmp/packages/media_notification_control-1.0.4/lib/media_notification.dart';

class Notification {
  Controller _controller;
  BuildContext _buildContext;

  Notification(Controller pController) {
    this._controller = pController;
    MediaNotification.setListener('pause', () {
      this._controller.soundManager.pause();
    });
    MediaNotification.setListener('play', () {
      this._controller.soundManager.play();
    });

    MediaNotification.setListener('next', () {
      this._controller.soundManager.nextSong();
    });

    MediaNotification.setListener('close', () {
      this.hideNotification();
    });
    MediaNotification.setListener('select', () {
      print("select");
      Navigator.of(this._buildContext, rootNavigator: true).pushNamed('/song/current');
    });
  }

  void setContext(BuildContext pContext) {
    this._buildContext = pContext;
  }

  void showNotification() async {
    print("test");
    await MediaNotification.show(
      play: true,
      title: this._controller.soundManager.currentSong.titel,
      author: this._controller.soundManager.currentSong.artist,
    );
  }

  void pauseNotification() async {
    await MediaNotification.show(
      play: false,
      title: this._controller.soundManager.currentSong.titel,
      author: this._controller.soundManager.currentSong.artist,
    );
  }

  void hideNotification() {
    MediaNotification.hide();
  }
}
